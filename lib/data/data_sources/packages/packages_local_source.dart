import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/package/package_dao.dart';
import 'package:perminda/data/db/models/package_item/package_item_dao.dart';
import 'package:perminda/data/remote_models/packages/results.dart';

abstract class PackagesLocalSource {
  Future<void> insertPackages(List<PackageTableCompanion> packages);
  Future<void> insertPackageItems(List<PackagesResult> packageItems);
  Stream<List<PackageData>> watchPackages();
  Future<int> deletePackageById(String packageId);
  Future<int> deletePackageItemById(String packageItemId);
}

class PackagesLocalSourceImpl extends PackagesLocalSource {
  final PackageDao packageDao;
  final PackageItemDao packageItemDao;

  PackagesLocalSourceImpl({this.packageDao, this.packageItemDao});

  @override
  Future<void> insertPackages(List<PackageTableCompanion> packages) {
    try {
      return packageDao.insertPackages(packages);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertPackageItems(List<PackagesResult> packages) {
    try {
      return packageItemDao.insertPackageItems(packages);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<PackageData>> watchPackages() {
    return packageItemDao.watchPackages();
  }

  @override
  Future<int> deletePackageById(String packageId) {
    return packageDao.deletePackageById(packageId);
  }

  @override
  Future<int> deletePackageItemById(String packageItemId) {
    return packageItemDao.deletePackageItemById(packageItemId);
  }
}
