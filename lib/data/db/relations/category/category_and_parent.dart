import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';

class CategoryAndParent extends Equatable {
  final CategoryData category;
  final CategoryData parent;

  CategoryAndParent({this.category, this.parent});

  @override
  List<Object> get props => [category, parent];

  @override
  bool get stringify => true;
}
