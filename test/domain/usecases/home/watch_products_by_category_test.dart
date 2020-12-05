import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  MockHomeRepo homeRepo;
  WatchProductsByCategoryUseCase watchProductsByCategoryUseCase;

  setUp(() {
    homeRepo = MockHomeRepo();
    watchProductsByCategoryUseCase = WatchProductsByCategoryUseCase(homeRepo);
  });

  test('should call watchProductsByCategory from [homeRepo]', () {
    watchProductsByCategoryUseCase(null);

    verify(homeRepo.watchProductsByCategory(null));
  });
}
