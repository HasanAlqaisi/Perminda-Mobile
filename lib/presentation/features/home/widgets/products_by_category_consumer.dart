import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/presentation/features/home/bloc/products_by_category_bloc/productsbycategory_bloc.dart';
import 'package:perminda/presentation/features/home/widgets/product_show.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

class ProductsByCategoryConsumer extends StatefulWidget {
  final CategoryData categoryData;

  ProductsByCategoryConsumer({
    this.categoryData,
  });

  @override
  _ProductsByCategoryConsumerState createState() =>
      _ProductsByCategoryConsumerState();
}

class _ProductsByCategoryConsumerState
    extends State<ProductsByCategoryConsumer> {
  final _productsByCategoryScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsbycategoryBloc>().add(RequestProductsByCategoryEvent(
          widget.categoryData.id,
          0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(left: 4),
        height: 250.0,
        child: BlocConsumer<ProductsbycategoryBloc, ProductsbycategoryState>(
          listener: (context, state) {
            if (state is ProductsByCategoryFailedState) {
              Fluttertoast.showToast(msg: failureToString(state.failure));
            }
          },
          builder: (context, state) {
            // if (state is ProductsByCategoryGottenState) {
            return StreamBuilder<List<ProductData>>(
                stream: context
                    .watch<ProductsbycategoryBloc>()
                    .watchProductsByCategory(widget.categoryData.id),
                initialData: [],
                builder: (context, snapshot) {
                  final productsData = snapshot.data;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          _productsByCategoryScroll.position.extentAfter == 0) {
                        context
                            .read<ProductsbycategoryBloc>()
                            .add(RequestProductsByCategoryEvent(
                              productsData[0]?.category,
                              productsData?.length,
                            ));
                      }
                      return false;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ListView.builder(
                          controller: _productsByCategoryScroll,
                          scrollDirection: Axis.horizontal,
                          itemCount: productsData?.length,
                          itemBuilder: (context, index) {
                            return ProductShow(
                                productData: productsData?.elementAt(index));
                          }),
                    ),
                  );
                });
            // } else {
            //   return Container();
            // }
          },
        ));
  }
}
