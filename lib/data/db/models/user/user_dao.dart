import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user/user_table.dart';

part 'user_dao.g.dart';

@UseDao(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<int> insertUser(UserTableCompanion user) =>
      into(userTable).insert(user, mode: InsertMode.insertOrReplace);

  Future<UserData> getUserById(String userId) =>
      (select(userTable)..where((userTable) => userTable.id.equals(userId)))
          .getSingle();

  Stream<UserData> watchUserById(String userId) =>
      (select(userTable)..where((userTable) => userTable.id.equals(userId)))
          .watchSingle();
}
