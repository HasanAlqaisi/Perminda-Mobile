
import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/data_sources/packages/packages_local_source.dart';
import 'package:perminda/data/db/models/package/package_table.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';
import 'package:perminda/domain/repos/packages_repo.dart';
import 'package:perminda/data/data_sources/packages/packages_remote_source.dart';

class PackagesRepoImpl extends PackagesRepo {
  final NetWorkInfo netWorkInfo;
  final PackagesRemoteSource remoteSource;
  final PackagesLocalSource localSource;
  int offset = 0;

  PackagesRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  void cacheOffset(int offset) {
    this.offset = offset;
  }

  @override
  Future<Either<Failure, Packages>> getPackages() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getPackages(this.offset);

        await localSource
            .insertPackages(PackageTable.fromPackagesResult(result.results));

        await localSource.insertPackageItems(result.results);

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

        return Right(result);
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
