import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:perminda/presentation/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:perminda/presentation/features/login/bloc/login_bloc.dart';
import 'package:perminda/presentation/features/registration/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'data/data_sources/auth/local_source.dart';
import 'data/data_sources/auth/remote_data_source.dart';
import 'data/db/app_database/app_database.dart';
import 'data/db/models/user/user_dao.dart';
import 'data/repos/auth/auth_repo_impl.dart';
import 'domain/repos/auth_repo.dart';
import 'domain/usecases/auth/forgot_password.dart';
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/register_user.dart';

final sl = GetIt.asNewInstance();

Future<void> init() async {
  //! Auth

  // bloc
  sl.registerFactory(() => RegisterBloc(registerUseCase: sl()));
  sl.registerFactory(() => LoginBloc(loginUserUseCase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgotPassUseCase: sl()));

  // registerUseCase
  sl.registerLazySingleton(() => RegisterUserUseCase(authRepo: sl()));

  // loginUserUseCase
  sl.registerLazySingleton(() => LoginUserUseCase(authRepo: sl()));

  // forgotPassUseCase
  sl.registerLazySingleton(() => ForgotPassUseCase(authRepo: sl()));

  // AuthRepo
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(
      netWorkInfo: sl(), remoteDataSource: sl(), userLocalSource: sl()));

  // RemoteDataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));

  // Local source
  sl.registerLazySingleton<UserLocalSource>(
      () => UserLocalSourceImpl(sharedPref: sl(), userDao: sl()));

  //! 3rd party

  // Shared Preferences
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

  // NetworkInfo
  sl.registerLazySingleton<NetWorkInfo>(
      () => NetWorkInfoImpl(connectionChecker: sl()));

  // Data connection checker
  sl.registerLazySingleton(() => DataConnectionChecker());

  // http client
  sl.registerLazySingleton(() => http.Client());

  //! Moor database

  //Query exceutor
  sl.registerLazySingletonAsync<QueryExecutor>(() async {
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return VmDatabase(file);
    });
  });

  //App database
  await sl.isReady<QueryExecutor>();
  sl.registerLazySingleton(() => AppDatabase(sl()));

  //User DAO
  sl.registerLazySingleton(() => UserDao(sl()));
}
