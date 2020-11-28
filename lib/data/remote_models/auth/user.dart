import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'first_name', nullable: true)
  final String firstName;
  @JsonKey(name: 'last_name', nullable: true)
  final String lastName;
  final String username;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(nullable: true)
  final String image;
  @JsonKey(nullable: true)
  final String address;
  @JsonKey(name: 'cart')
  final List<String> cartProducts;
  @JsonKey(name: 'wishlist')
  final List<String> wishlistProducts;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_staff')
  final bool isStaff;
  @JsonKey(name: 'is_superuser')
  final bool isSuperUser;
  @JsonKey(name: 'is_seller')
  final bool isSeller;
  @JsonKey(name: 'date_joined')
  final String dateJoind;
  @JsonKey(name: 'last_login', nullable: true)
  final String lastLogin;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phoneNumber,
    this.image,
    this.address,
    this.cartProducts,
    this.wishlistProducts,
    this.isActive,
    this.isStaff,
    this.isSuperUser,
    this.isSeller,
    this.dateJoind,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [firstName, lastName, username, email];
}
