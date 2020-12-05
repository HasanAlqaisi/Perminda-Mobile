part of 'productsbycategory_bloc.dart';

abstract class ProductsbycategoryEvent extends Equatable {
  const ProductsbycategoryEvent();

  @override
  List<Object> get props => [];
}

class RequestProductsByCategoryEvent extends ProductsbycategoryEvent {
  final String categoryId;
  final int offset;

  RequestProductsByCategoryEvent(this.categoryId, this.offset);
}
