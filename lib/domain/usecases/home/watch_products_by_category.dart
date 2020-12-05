import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class WatchProductsByCategoryUseCase {
  final HomeRepo homeRepo;

  WatchProductsByCategoryUseCase(this.homeRepo);

  Stream<List<ProductData>> call(String categoryId) {
    return homeRepo.watchProductsByCategory(categoryId);
  }
}
