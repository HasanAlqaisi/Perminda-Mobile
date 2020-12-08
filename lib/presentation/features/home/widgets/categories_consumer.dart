import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/presentation/features/home/bloc/categories_bloc/categories_bloc.dart';

import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/presentation/features/home/pages/test_screen.dart';
import 'package:perminda/presentation/features/home/widgets/products_by_category_consumer.dart';

class CategoriesConsumer extends StatefulWidget {
  @override
  _CategoriesConsumerState createState() => _CategoriesConsumerState();
}

class _CategoriesConsumerState extends State<CategoriesConsumer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFailedState) {
          Fluttertoast.showToast(msg: failureToString(state.failure));
        }
      },
      builder: (context, state) {
        // if (state is CategoriesGottenState) {
        return Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: StreamBuilder<List<CategoryData>>(
              stream: context.watch<CategoriesBloc>().watchCategoriesUseCase(),
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
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TestScreen())),
                                  child: Text(
                                    'See more',
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ProductsByCategoryConsumer(
                            categoryData: categoriesData[index],
                          ),
                        ],
                      );
                    });
              }),
        );
        // } else {
        //   return Container();
        // }
      },
    );
  }
}
