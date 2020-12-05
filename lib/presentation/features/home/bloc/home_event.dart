part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class RequestPackagesEvent extends HomeEvent {
  RequestPackagesEvent();
}

class RequestCategoriesEvent extends HomeEvent {
  RequestCategoriesEvent();
}

class RequestProductsByCategoryEvent extends HomeEvent {
  final String categoryId;
  final int offset;

  RequestProductsByCategoryEvent(this.categoryId, this.offset);
}

// class WatchPackagesEvent extends HomeEvent {
//   WatchPackagesEvent();
// }