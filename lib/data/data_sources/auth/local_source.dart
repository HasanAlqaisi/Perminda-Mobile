import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalSource {
  Future<int> insertUser(UserTableCompanion user);

  Future<UserData> getUserById(String userId);

  Stream<UserData> watchUserById(String userId);

  Future<void> cacheUserToken(String token);

  Future<void> cacheUserId(String userId);
}

class UserLocalSourceImpl extends UserLocalSource {
  final UserDao userDao;
  final SharedPreferences sharedPref;

  UserLocalSourceImpl({this.userDao, this.sharedPref});

  @override
  Future<UserData> getUserById(String userId) {
    return userDao.getUserById(userId);
  }

  @override
  Future<int> insertUser(UserTableCompanion user) {
    try {
      return userDao.insertUser(user);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<UserData> watchUserById(String userId) {
    return userDao.watchUserById(userId);
  }

  @override
  Future<void> cacheUserToken(String token) {
    return sharedPref.setString(cachedTokenKey, token);
  }

  @override
  Future<void> cacheUserId(String userId) {
    return sharedPref.setString(cachedUserIdKey, userId);
  }
}
