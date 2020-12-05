import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TriggerPackagesUseCase triggerPackagesCase;
  final TriggerProductsByCategoryUseCase triggerProductsByCategoryCase;
  final WatchProductsByCategoryUseCase watchProductsByCategoryCase;
  final WatchPackagesUseCase watchPackagesCase;
  final TriggerCategoriesUseCase triggerCategoriesCase;
  final WatchCategoriesUseCase watchCategoriesUseCase;

  HomeBloc({
    this.triggerCategoriesCase,
    this.triggerPackagesCase,
    this.triggerProductsByCategoryCase,
    this.watchPackagesCase,
    this.watchProductsByCategoryCase,
    this.watchCategoriesUseCase,
  }) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is RequestPackagesEvent) {
      final packagesFailure = await triggerPackagesCase();
      if (packagesFailure == null) {
        yield PackagesGottenState();
      } else {
        yield PackagesFailedState(packagesFailure);
      }
    } else if (event is RequestCategoriesEvent) {
      final categoriesFailure = await triggerCategoriesCase();
      if (categoriesFailure == null) {
        yield CategoriesGottenState();
      } else {
        yield CategoriesFailedState(categoriesFailure);
      }
    } else if (event is RequestProductsByCategoryEvent) {
      final productsByCategoryFailure =
          await triggerProductsByCategoryCase(event.categoryId, event.offset);

      if (productsByCategoryFailure == null) {
        yield ProductsByCategoryGottenState();
      } else {
        yield ProductsByCategoryFailedState(productsByCategoryFailure);
      }
    }
  }

  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }

  Stream<List<ProductData>> watchProductsByCategory(String categoryId) {
    return watchProductsByCategoryCase(categoryId);
  }

  Stream<List<CategoryData>> watchCategories() {
    return watchCategoriesUseCase();
  }

  Stream<List<PackageData>> watchPackages() {
    return watchPackagesCase();
  }
}
