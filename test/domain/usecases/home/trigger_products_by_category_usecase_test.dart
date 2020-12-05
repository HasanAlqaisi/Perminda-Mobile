import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  MockHomeRepo homeRepo;
  TriggerProductsByCategoryUseCase triggerProductsByCategoryUseCase;

  setUp(() {
    homeRepo = MockHomeRepo();
    triggerProductsByCategoryUseCase =
        TriggerProductsByCategoryUseCase(homeRepo);
  });

  test('should call triggerProductsByCategory from [homeRepo]', () {
    triggerProductsByCategoryUseCase(null);

    verify(homeRepo.triggerProductsByCategory(null));
  });
}
