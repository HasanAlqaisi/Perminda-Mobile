import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:perminda/data/data_sources/brands/local_source.dart';
import 'package:perminda/data/data_sources/brands/remote_source.dart';
import 'package:perminda/data/data_sources/categories/local_source.dart';
import 'package:perminda/data/data_sources/categories/remote_soruce.dart';
import 'package:perminda/data/data_sources/packages/packages_local_source.dart';
import 'package:perminda/data/data_sources/products/products_local_source.dart';
import 'package:perminda/data/data_sources/products/products_remote_source.dart';
import 'package:perminda/data/data_sources/shops/shops_local_source.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/db/models/category/category_dao.dart';
import 'package:perminda/data/db/models/package/package_dao.dart';
import 'package:perminda/data/db/models/package_item/package_item_dao.dart';
import 'package:perminda/data/db/models/product/product_dao.dart';
import 'package:perminda/data/db/models/shop/shop_dao.dart';
import 'package:perminda/data/repos/brands/brands_repo_impl.dart';
import 'package:perminda/data/repos/categories/categories_repo_impl.dart';
import 'package:perminda/data/repos/main/home/home_repo_impl.dart';
import 'package:perminda/data/repos/packages/packages_repo_impl.dart';
import 'package:perminda/data/repos/products/products_repo_impl.dart';
import 'package:perminda/data/repos/shops/shops_repo_impl.dart';
import 'package:perminda/domain/repos/brands_repo.dart';
import 'package:perminda/domain/repos/categories_repo.dart';
import 'package:perminda/domain/repos/packages_repo.dart';
import 'package:perminda/domain/repos/products_repo.dart';
import 'package:perminda/domain/repos/shops_repo.dart';
import 'package:perminda/domain/usecases/auth/get_token_use_case.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';
import 'package:perminda/presentation/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/categories_bloc/categories_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/home_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/packages_bloc/packages_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/products_by_category_bloc/productsbycategory_bloc.dart';
import 'package:perminda/presentation/features/login/bloc/login_bloc.dart';
import 'package:perminda/presentation/features/registration/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perminda/data/data_sources/packages/packages_remote_source.dart';
import 'package:perminda/data/db/models/brand/brand_dao.dart';

import 'core/network/network_info.dart';
import 'data/data_sources/auth/local_source.dart';
import 'data/data_sources/auth/remote_data_source.dart';
import 'data/db/app_database/app_database.dart';
import 'data/db/models/user/user_dao.dart';
import 'data/repos/auth/auth_repo_impl.dart';
import 'domain/repos/auth_repo.dart';
import 'domain/repos/main/home_repo.dart';
import 'domain/usecases/auth/forgot_password.dart';
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/register_user.dart';

final sl = GetIt.asNewInstance();

Future<void> init() async {
  //! Auth

  // bloc
  sl.registerFactory(() => RegisterBloc(registerUseCase: sl()));
  sl.registerFactory(
      () => LoginBloc(loginUserUseCase: sl(), getTokenUseCase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgotPassUseCase: sl()));
  // sl.registerFactory(() => HomeBloc(
  //       triggerCategoriesCase: sl(),
  //       triggerPackagesCase: sl(),
  //       triggerProductsByCategoryCase: sl(),
  //       watchPackagesCase: sl(),
  //       watchProductsByCategoryCase: sl(),
  //       watchCategoriesUseCase: sl(),
  //     ));
  sl.registerFactory(() => PackagesBloc(
        triggerPackagesCase: sl(),
        watchPackagesCase: sl(),
      ));
  sl.registerFactory(() => CategoriesBloc(
        triggerCategoriesCase: sl(),
        watchCategoriesUseCase: sl(),
      ));
  sl.registerFactory(() => ProductsbycategoryBloc(
        triggerProductsByCategoryCase: sl(),
        watchProductsByCategoryCase: sl(),
      ));

  // registerUseCase
  sl.registerLazySingleton(() => RegisterUserUseCase(authRepo: sl()));

  // loginUserUseCase
  sl.registerLazySingleton(() => LoginUserUseCase(authRepo: sl()));

  // GetTokenUseCase
  sl.registerLazySingleton(() => GetTokenUseCase(authRepo: sl()));

  // forgotPassUseCase
  sl.registerLazySingleton(() => ForgotPassUseCase(authRepo: sl()));

  // triggerCategoriesCase
  sl.registerLazySingleton(() => TriggerCategoriesUseCase(sl()));

  // TriggerPackagesUseCase
  sl.registerLazySingleton(() => TriggerPackagesUseCase(sl()));

  // TriggerProductsByCategoryUseCase
  sl.registerLazySingleton(() => TriggerProductsByCategoryUseCase(sl()));

  // WatchPackagesUseCase
  sl.registerLazySingleton(() => WatchPackagesUseCase(sl()));

  // WatchProductsByCategoryUseCase
  sl.registerLazySingleton(() => WatchProductsByCategoryUseCase(sl()));

  // WatchCategoriesUseCase
  sl.registerLazySingleton(() => WatchCategoriesUseCase(sl()));

  // AuthRepo
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(
      netWorkInfo: sl(), remoteDataSource: sl(), userLocalSource: sl()));

  // HomeRepo
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(
        netWorkInfo: sl(),
        shopsRepo: sl(),
        categoriesRepo: sl(),
        brandsRepo: sl(),
        packagesRepo: sl(),
        productsRepo: sl(),
      ));

  // ShopsRepo
  sl.registerLazySingleton<ShopsRepo>(() => ShopsRepoImpl(
        netWorkInfo: sl(),
        remoteSource: sl(),
        localSource: sl(),
      ));

  // CategoriesRepo
  sl.registerLazySingleton<CategoriesRepo>(() => CategoriesRepoImpl(
        netWorkInfo: sl(),
        remoteSource: sl(),
        localSource: sl(),
      ));

  // BrandsRepo
  sl.registerLazySingleton<BrandsRepo>(() => BrandsRepoImpl(
        netWorkInfo: sl(),
        remoteSource: sl(),
        localSource: sl(),
      ));

  // PackagesRepo
  sl.registerLazySingleton<PackagesRepo>(() => PackagesRepoImpl(
        netWorkInfo: sl(),
        remoteSource: sl(),
        localSource: sl(),
      ));

  // ProductsRepo
  sl.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl(
        netWorkInfo: sl(),
        remoteSource: sl(),
        localSource: sl(),
      ));

  //! Remote Sources

  // Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));

  // ShopsRemoteSource
  sl.registerLazySingleton<ShopsRemoteSource>(
      () => ShopsRemoteSourceImpl(client: sl()));

  // CategoriesRemoteSource
  sl.registerLazySingleton<CategoriesRemoteSource>(
      () => CategoriesRemoteSourceImpl(client: sl()));

  // BrandsRemoteSource
  sl.registerLazySingleton<BrandsRemoteSource>(
      () => BrandsRemoteSourceImpl(client: sl()));

  // PackagesRemoteSource
  sl.registerLazySingleton<PackagesRemoteSource>(
      () => PackagesRemoteSourceImpl(client: sl()));

  // ProductsRemoteSource
  sl.registerLazySingleton<ProductsRemoteSource>(
      () => ProductsRemoteSourceImpl(client: sl()));

  //! Local sources

  // User Local source
  sl.registerLazySingleton<UserLocalSource>(
      () => UserLocalSourceImpl(sharedPref: sl(), userDao: sl()));

  // ShopsLocalSource
  sl.registerLazySingleton<ShopsLocalSource>(
      () => ShopsLocalSourceImpl(shopDao: sl()));

  // CategoriesLocalSource
  sl.registerLazySingleton<CategoriesLocalSource>(
      () => CategoriesLocalSourceImpl(categoryDao: sl()));

  // BrandLocalSource
  sl.registerLazySingleton<BrandLocalSource>(
      () => BrandLocalSourceImpl(brandDao: sl()));

  // PackagesRemoteSource
  sl.registerLazySingleton<PackagesLocalSource>(
      () => PackagesLocalSourceImpl(packageDao: sl(), packageItemDao: sl()));

  // ProductsLocalSource
  sl.registerLazySingleton<ProductsLocalSource>(
      () => ProductsLocalSourceImpl(productDao: sl()));

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

  //! DAOs

  //User DAO
  sl.registerLazySingleton(() => UserDao(sl()));

// Category DAO
  sl.registerLazySingleton(() => CategoryDao(sl()));

// Shop DAO
  sl.registerLazySingleton(() => ShopDao(sl()));

  sl.registerLazySingleton(() => BrandDao(sl()));

// Package DAO
  sl.registerLazySingleton(() => PackageDao(sl()));

// PackageItem DAO
  sl.registerLazySingleton(() => PackageItemDao(sl()));

// Product DAO
  sl.registerLazySingleton(() => ProductDao(sl()));
}
