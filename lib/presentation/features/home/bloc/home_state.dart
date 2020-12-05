part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class PackagesGottenState extends HomeState {}

class PackagesFailedState extends HomeState {
  final Failure failure;

  PackagesFailedState(this.failure);
}

class CategoriesGottenState extends HomeState {}

class CategoriesFailedState extends HomeState {
  final Failure failure;

  CategoriesFailedState(this.failure);
}

class ProductsByCategoryGottenState extends HomeState {}

class ProductsByCategoryFailedState extends HomeState {
  final Failure failure;

  ProductsByCategoryFailedState(this.failure);
}
