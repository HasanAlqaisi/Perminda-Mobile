import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_categories_usecase.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final TriggerCategoriesUseCase triggerCategoriesCase;
  final WatchCategoriesUseCase watchCategoriesUseCase;

  CategoriesBloc({
    this.triggerCategoriesCase,
    this.watchCategoriesUseCase,
  }) : super(CategoriesInitial());

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is RequestCategoriesEvent) {
      final categoriesFailure = await triggerCategoriesCase();
      if (categoriesFailure == null) {
        yield CategoriesGottenState();
      } else {
        yield CategoriesFailedState(categoriesFailure);
      }
    }
  }

  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }

  Stream<List<CategoryData>> watchCategories() {
    return watchCategoriesUseCase();
  }
}
