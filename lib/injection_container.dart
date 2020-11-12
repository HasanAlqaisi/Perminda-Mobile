import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/domain/usecases/auth/register_user.dart';

import 'core/network/network_info.dart';
import 'data/repos/auth/auth_repo_impl.dart';
import 'domain/repos/auth_repo.dart';
import 'presentation/features/registration/bloc/register_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.asNewInstance();

void init() {
  //! Auth

  // bloc
  sl.registerFactory(() => RegisterBloc(registerUseCase: sl()));

  // registerUseCase
  sl.registerLazySingleton(() => RegisterUserUseCase(authRepo: sl()));

  // AuthRepo
  sl.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(netWorkInfo: sl(), remoteDataSource: sl()));

  // RemoteDataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));

  //! 3rd party

  // NetworkInfo
  sl.registerLazySingleton<NetWorkInfo>(
      () => NetWorkInfoImpl(connectionChecker: sl()));

  // Data connection checker
  sl.registerLazySingleton(() => DataConnectionChecker());

  // http client
  sl.registerLazySingleton(() => http.Client());
}
