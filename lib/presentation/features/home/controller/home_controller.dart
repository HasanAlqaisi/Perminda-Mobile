import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final TriggerPackagesUseCase triggerPackagesCase;
  final WatchPackagesUseCase watchPackagesCase;
  final TriggerCategoriesUseCase triggerCategoriesCase;
  final WatchCategoriesUseCase watchCategoriesUseCase;
  final TriggerProductsByCategoryUseCase triggerProductsByCategoryCase;
  final WatchProductsByCategoryUseCase watchProductsByCategoryCase;

  ScrollController categoriesScroll;
  ScrollController productsByCategoryScroll;

  HomeController(
    this.triggerPackagesCase,
    this.watchPackagesCase,
    this.triggerCategoriesCase,
    this.watchCategoriesUseCase,
    this.triggerProductsByCategoryCase,
    this.watchProductsByCategoryCase,
  );

  @override
  void onInit() {
    super.onInit();
    categoriesScroll = ScrollController();
    productsByCategoryScroll = ScrollController();

    final result = Future.wait([
      triggerPackagesCase(),
      triggerCategoriesCase(),
    ]);

    result.then((failures) => failures.map((failure) {
          if (failure != null)
            Fluttertoast.showToast(msg: failureToString(failure));
        }));
  }

  void onCategoryGotten(String categoryId, int offset) async {
    triggerProductsByCategoryCase(categoryId, offset).then((value) {
      if (value != null) Fluttertoast.showToast(msg: failureToString(value));
    });
  }

  bool handleCategoriesScrolling(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      triggerCategoriesCase().then((value) {
        if (value != null) Fluttertoast.showToast(msg: failureToString(value));
      });
    }
    return false;
  }

  bool handleProductsScrolling(
      ScrollNotification notification, String categoryId, int offset) {
    if (notification is ScrollEndNotification) {
      onCategoryGotten(categoryId, offset);
    }
    return false;
  }

  Stream<List<PackageData>> watchPackages() {
    return watchPackagesCase();
  }

  Stream<List<CategoryData>> watchCategories() {
    return watchCategoriesUseCase();
  }

  Stream<List<ProductData>> watchProductsByCategory(String categoryId) {
    return watchProductsByCategoryCase(categoryId);
  }

  @override
  void onClose() {
    super.onClose();
    categoriesScroll.dispose();
    productsByCategoryScroll.dispose();
  }
}
