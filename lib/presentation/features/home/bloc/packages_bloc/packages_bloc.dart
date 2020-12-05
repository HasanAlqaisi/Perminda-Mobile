import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

part 'packages_event.dart';
part 'packages_state.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final TriggerPackagesUseCase triggerPackagesCase;
  final WatchPackagesUseCase watchPackagesCase;

  PackagesBloc({
    this.triggerPackagesCase,
    this.watchPackagesCase,
  }) : super(PackagesInitial());

  @override
  Stream<PackagesState> mapEventToState(
    PackagesEvent event,
  ) async* {
    if (event is RequestPackagesEvent) {
      final packagesFailure = await triggerPackagesCase();
      if (packagesFailure == null) {
        yield PackagesGottenState();
      } else {
        yield PackagesFailedState(packagesFailure);
      }
    }
  }

  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }

  Stream<List<PackageData>> watchPackages() {
    return watchPackagesCase();
  }
}
