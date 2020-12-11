import 'package:flutter/material.dart';

import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/presentation/features/home/controller/home_controller.dart';
import 'package:perminda/presentation/features/home/widgets/products_by_category.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: StreamBuilder<List<CategoryData>>(
          stream: HomeController.to.watchCategoriesUseCase(),
          builder: (context, snapshot) {
            final categoriesData = snapshot.data;

            return ListView.builder(
                itemCount: categoriesData?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categoriesData[index].name,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                            Text(
                              'See more',
                              style:
                                  TextStyle(fontSize: 10.0, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      ProductsByCategory(
                        categoryData: categoriesData[index],
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
