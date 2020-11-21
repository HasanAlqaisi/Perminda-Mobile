import 'package:equatable/equatable.dart';

abstract class Failure {}

class UserFieldsFailure extends Equatable implements Failure {
  final List<String> firstName;
  final List<String> lastName;
  final List<String> userName;
  final List<String> email;
  final List<String> phone;
  final List<String> password;
  final List<String> address;
  final List<String> image;

  UserFieldsFailure(
      {this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.phone,
      this.password,
      this.address,
      this.image});

  factory UserFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return UserFieldsFailure(
      email: body['email']?.cast<String>() as List<String>,
      firstName: body['first_name']?.cast<String>() as List<String> ?? null,
      lastName: body['last_name']?.cast<String>() as List<String> ?? null,
      password: body['password']?.cast<String>() as List<String> ?? null,
      phone: body['phone_number']?.cast<String>() as List<String> ?? null,
      userName: body['username']?.cast<String>() as List<String> ?? null,
      address: body['address']?.cast<String>() as List<String> ?? null,
      image: body['image']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  List<Object> get props =>
      [firstName, lastName, userName, email, password, address, image];

  @override
  bool get stringify => true;
}

class UnknownFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NoInternetFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class NonFieldsFailure extends Equatable implements Failure {
  final List<String> errors;

  NonFieldsFailure({this.errors});

  @override
  List<Object> get props => [errors];

  factory NonFieldsFailure.fromNonFieldsException(Map<String, dynamic> body) {
    return NonFieldsFailure(
      errors: body['non_field_errors']?.cast<String>() as List<String> ?? null,
    );
  }
}

class ItemNotFoundFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class UnauthorizedTokenFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class NotAllowedPermissionFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class ReviewFieldsFailure extends Equatable implements Failure {
  final List<String> rate;
  final List<String> message;
  final List<String> productId;

  ReviewFieldsFailure({this.rate, this.message, this.productId});

  factory ReviewFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return ReviewFieldsFailure(
      rate: body['rate']?.cast<String>() as List<String> ?? null,
      message: body['message']?.cast<String>() as List<String> ?? null,
      productId: body['product']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  List<Object> get props => [rate, message, productId];
}

class ProductImageFieldsFailure extends Equatable implements Failure {
  final List<String> image;
  final List<String> type;
  final List<String> product;

  ProductImageFieldsFailure({this.image, this.type, this.product});

  factory ProductImageFieldsFailure.fromFieldsException(
      Map<String, dynamic> body) {
    return ProductImageFieldsFailure(
      image: body['image']?.cast<String>() as List<String> ?? null,
      type: body['type']?.cast<String>() as List<String> ?? null,
      product: body['product']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  List<Object> get props => [image, type, product];
}
