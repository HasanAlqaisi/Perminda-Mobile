import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  MockHomeRepo homeRepo;
  TriggerCategoriesUseCase triggerCategoriesUseCase;

  setUp(() {
    homeRepo = MockHomeRepo();
    triggerCategoriesUseCase = TriggerCategoriesUseCase(homeRepo);
  });

  test('should call triggerCategories from [homeRepo]', () {
    triggerCategoriesUseCase();

    verify(homeRepo.triggerCategories());
  });
}
