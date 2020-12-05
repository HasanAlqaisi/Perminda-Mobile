import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class WatchCategoriesUseCase {
  final HomeRepo homeRepo;

  WatchCategoriesUseCase(this.homeRepo);

  Stream<List<CategoryData>> call() {
    return homeRepo.watchCategories();
  }
}
