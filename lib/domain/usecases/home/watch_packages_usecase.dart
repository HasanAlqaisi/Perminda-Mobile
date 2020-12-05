import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class WatchPackagesUseCase {
  final HomeRepo homeRepo;

  WatchPackagesUseCase(this.homeRepo);

  Stream<List<PackageData>> call() {
    return homeRepo.watchPackages();
  }
}
