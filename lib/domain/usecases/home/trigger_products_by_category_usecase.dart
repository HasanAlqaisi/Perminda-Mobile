import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class TriggerProductsByCategoryUseCase {
  final HomeRepo homeRepo;

  TriggerProductsByCategoryUseCase(this.homeRepo);

  Future<Failure> call(String categoryId, int offset) async {
    return await homeRepo.triggerProductsByCategory(categoryId, offset);
  }
}
