import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';

class TriggerPackagesUseCase {
  final HomeRepo homeRepo;

  TriggerPackagesUseCase(this.homeRepo);

  Future<Failure> call() async{
    return await homeRepo.triggerPackages();
  }
}
