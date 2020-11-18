import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String username;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String image;
  final String address;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phoneNumber,
    this.image,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [firstName, lastName, username, email];
}
