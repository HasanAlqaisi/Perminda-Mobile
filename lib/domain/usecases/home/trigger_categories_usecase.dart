import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class TriggerCategoriesUseCase {
  final HomeRepo homeRepo;

  TriggerCategoriesUseCase(this.homeRepo);

  Future<Failure> call() async {
    return await homeRepo.triggerCategories();
  }
}
