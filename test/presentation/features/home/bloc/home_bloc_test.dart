import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/home/trigger_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/trigger_products_by_category_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_categories_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_packages_usecase.dart';
import 'package:perminda/domain/usecases/home/watch_products_by_category.dart';
import 'package:perminda/presentation/features/home/bloc/home_bloc.dart';

class MockTriggerCategoriesCase extends Mock
    implements TriggerCategoriesUseCase {}

class MockTriggerPackagesCase extends Mock implements TriggerPackagesUseCase {}

class MockTriggerProductsByCategoryCase extends Mock
    implements TriggerProductsByCategoryUseCase {}

class MockWatchPackagesCase extends Mock implements WatchPackagesUseCase {}

class MockWatchProductsCase extends Mock
    implements WatchProductsByCategoryUseCase {}

class MockWatchCategoriesUseCase extends Mock
    implements WatchCategoriesUseCase {}

void main() {
  MockTriggerCategoriesCase triggerCategoriesCase;
  MockTriggerPackagesCase triggerPackagesCase;
  MockTriggerProductsByCategoryCase triggerProductsByCategoryCase;
  MockWatchPackagesCase watchPackagesCase;
  MockWatchProductsCase watchProductsByCategoryCase;
  MockWatchCategoriesUseCase watchCategoriesUseCase;
  HomeBloc homeBloc;

  setUp(() {
    triggerCategoriesCase = MockTriggerCategoriesCase();
    triggerPackagesCase = MockTriggerPackagesCase();
    triggerProductsByCategoryCase = MockTriggerProductsByCategoryCase();
    watchPackagesCase = MockWatchPackagesCase();
    watchProductsByCategoryCase = MockWatchProductsCase();
    watchCategoriesUseCase = MockWatchCategoriesUseCase();
    homeBloc = HomeBloc(
      triggerCategoriesCase: triggerCategoriesCase,
      triggerPackagesCase: triggerPackagesCase,
      triggerProductsByCategoryCase: triggerProductsByCategoryCase,
      watchPackagesCase: watchPackagesCase,
      watchProductsByCategoryCase: watchProductsByCategoryCase,
      watchCategoriesUseCase: watchCategoriesUseCase,
    );
  });

  tearDown(() {
    homeBloc.close();
  });

  group('RequestDataEvent', () {
    test('should emit [PackagesGottenState] when call is success', () {
      when(triggerPackagesCase()).thenAnswer((_) async => null);

      final expectedState = [PackagesGottenState()];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestPackagesEvent());
    });
    test('should emit [PackagesFailedState] when call is success', () {
      final unknownFailure = UnknownFailure();

      when(triggerPackagesCase()).thenAnswer((_) async => UnknownFailure());

      final expectedState = [PackagesFailedState(unknownFailure)];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestPackagesEvent());
    });
  });

  group('RequestCategoriesEvent', () {
    test('should emit [CategoriesGottenState] when call is success', () {
      when(triggerCategoriesCase()).thenAnswer((_) async => null);

      final expectedState = [CategoriesGottenState()];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestCategoriesEvent());
    });
    test('should emit [CategoriesFailedState] when call is success', () {
      final unknownFailure = UnknownFailure();

      when(triggerCategoriesCase()).thenAnswer((_) async => UnknownFailure());

      final expectedState = [CategoriesFailedState(unknownFailure)];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestCategoriesEvent());
    });
  });

  group('RequestProductsByCategoryEvent', () {
    test('should emit [ProductsByCategoryGottenState] when call is success',
        () {
      when(triggerProductsByCategoryCase(null)).thenAnswer((_) async => null);

      final expectedState = [ProductsByCategoryGottenState()];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestProductsByCategoryEvent(null));
    });
    test('should emit [ProductsByCategoryFailedState] when call is success',
        () {
      final unknownFailure = UnknownFailure();

      when(triggerProductsByCategoryCase(null))
          .thenAnswer((_) async => UnknownFailure());

      final expectedState = [ProductsByCategoryFailedState(unknownFailure)];

      expectLater(homeBloc.asBroadcastStream(), emitsInOrder(expectedState));

      homeBloc.add(RequestProductsByCategoryEvent(null));
    });
  });

  group('watchPackages', () {
    test('should call watchPackagesCase', () {
      homeBloc.watchPackages();

      verify(watchPackagesCase());
    });
  });

  group('watchProductsByCategory', () {
    test('should call watchProductsByCategoryCase', () {
      homeBloc.watchProductsByCategory(null);

      verify(watchProductsByCategoryCase(null));
    });
  });

  group('watchCategories', () {
    test('should call watchCategoriesUseCase', () {
      homeBloc.watchCategories();

      verify(watchCategoriesUseCase());
    });
  });
}
