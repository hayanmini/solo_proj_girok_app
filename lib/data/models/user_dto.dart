import 'package:flutter_girok_app/domain/models/user.dart';

// DTO 파이어베이스 전용 모델

class UserDto {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserDto({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserDto.fromDomain(User user) => UserDto(
    id: user.id,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoUrl,
  );

  User toDomain() =>
      User(id: id, email: email, displayName: displayName, photoUrl: photoUrl);

  factory UserDto.fromFirestore(Map<String, dynamic> json) => UserDto(
    id: json["id"],
    email: json["email"],
    displayName: json["displayName"],
    photoUrl: json["photoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "displayName": displayName,
    "photoUrl": photoUrl,
  };
}
