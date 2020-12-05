part of 'productsbycategory_bloc.dart';

abstract class ProductsbycategoryState extends Equatable {
  const ProductsbycategoryState();

  @override
  List<Object> get props => [];
}

class ProductsbycategoryInitial extends ProductsbycategoryState {}

class ProductsByCategoryGottenState extends ProductsbycategoryState {}

class ProductsByCategoryFailedState extends ProductsbycategoryState {
  final Failure failure;

  ProductsByCategoryFailedState(this.failure);
}
