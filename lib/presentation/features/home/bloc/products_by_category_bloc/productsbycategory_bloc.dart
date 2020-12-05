import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

part 'productsbycategory_event.dart';
part 'productsbycategory_state.dart';

class ProductsbycategoryBloc
    extends Bloc<ProductsbycategoryEvent, ProductsbycategoryState> {
  final TriggerProductsByCategoryUseCase triggerProductsByCategoryCase;
  final WatchProductsByCategoryUseCase watchProductsByCategoryCase;

  ProductsbycategoryBloc({
    this.triggerProductsByCategoryCase,
    this.watchProductsByCategoryCase,
  }) : super(ProductsbycategoryInitial());

  @override
  Stream<ProductsbycategoryState> mapEventToState(
    ProductsbycategoryEvent event,
  ) async* {
    if (event is RequestProductsByCategoryEvent) {
      print('mapEventToState called');
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
}
