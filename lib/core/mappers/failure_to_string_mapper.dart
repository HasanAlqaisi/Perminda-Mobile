import 'package:perminda/core/errors/failure.dart';

String failureToString(Failure failure) {
  if (failure is UnknownFailure) {
    return 'something went wrong..';
  } else if (failure is NoInternetFailure) {
    return 'No internet connection';
  } else if (failure is UnauthorizedTokenFailure) {
    return 'login to make this request';
  } else if (failure is NotAllowedPermissionFailure) {
    return 'You are not allowed to make this request';
  } else if (failure is CacheFailure) {
    return 'Error caching the data';
  } else if (failure is ItemNotFoundFailure) {
    return 'Item not found!';
  } else if (failure is NoMorePagesFailure) {
    return 'No more results';
  } else if (failure is NonFieldsFailure) {
    return failure?.errors?.first;
  } else {
    return 'Unknown';
  }
}
