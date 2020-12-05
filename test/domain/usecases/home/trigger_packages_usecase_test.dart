import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  MockHomeRepo homeRepo;
  TriggerPackagesUseCase triggerPackagesUseCase;

  setUp(() {
    homeRepo = MockHomeRepo();
    triggerPackagesUseCase = TriggerPackagesUseCase(homeRepo);
  });

  test('should call triggerPackages from [homeRepo]', () {
    triggerPackagesUseCase();

    verify(homeRepo.triggerPackages());
  });
}
