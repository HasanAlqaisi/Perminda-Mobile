import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:perminda/presentation/features/home/controller/home_controller.dart';
import 'package:perminda/presentation/features/home/widgets/product_show.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:shimmer/shimmer.dart';

class ProductsByCategory extends StatelessWidget {
  final CategoryData categoryData;

  ProductsByCategory({this.categoryData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) {
        HomeController.to.onCategoryGotten(categoryData.id, 0);
      },
      builder: (_) {
        return Container(
          height: 250.0,
          child: StreamBuilder<List<ProductData>>(
              stream: _.watchProductsByCategory(categoryData.id),
              initialData: [],
              builder: (context, snapshot) {
                final productsData = snapshot.data;
                if (snapshot.data == null || snapshot.data.isEmpty) {
                  return Shimmer.fromColors(
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey[300],
                            width: 160,
                            height: 250,
                            margin: EdgeInsets.all(5),
                          );
                        },
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100]);
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return _.handleProductsScrolling(
                      notification,
                      productsData[0]?.category,
                      productsData?.length,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListView.builder(
                        controller: _.productsByCategoryScroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: productsData?.length,
                        itemBuilder: (context, index) {
                          return ProductShow(
                              productData: productsData?.elementAt(index));
                        }),
                  ),
                );
              }),
          // } else {
          //   return Container();
          // }
        );
      },
    );
  }
}
