import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/auth/user.dart';

@DataClassName('UserData')
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get address => text().nullable()();
  TextColumn get image => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(Constant(false))();
  BoolColumn get isSuperUser => boolean().withDefault(Constant(false))();
  BoolColumn get isStaff => boolean().withDefault(Constant(false))();
  BoolColumn get isSeller => boolean().withDefault(Constant(false))();
  DateTimeColumn get dateJoined => dateTime()();
  DateTimeColumn get lastLogin => dateTime().nullable()();

  @override
  String get tableName => 'user_table';

  @override
  Set<Column> get primaryKey => {id};

  static UserTableCompanion fromUser(User user) {
    return UserTableCompanion(
      id: Value(user.id),
      firstName: Value(user.firstName),
      lastName: Value(user.lastName),
      username: Value(user.username),
      email: Value(user.email),
      phoneNumber: Value(user.phoneNumber),
      image: Value(user.image),
      address: Value(user.address),
      isActive: Value(user.isActive),
      isSuperUser: Value(user.isSuperUser),
      isStaff: Value(user.isStaff),
      isSeller: Value(user.isSeller),
      dateJoined: Value(DateTime.tryParse(user.dateJoind)),
      lastLogin: Value(
          user.lastLogin != null ? DateTime.tryParse(user.lastLogin) : null),
    );
  }
}
