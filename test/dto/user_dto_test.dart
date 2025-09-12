import 'package:flutter_girok_app/data/models/user_dto.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("userDto Test", () {
    final user = User(
      id: "uid123",
      email: "test@test.com",
      displayName: "tester",
      photoUrl: "http://photo.url",
    );

    test("User > userDto > JSON > User", () {
      final dto = UserDto.fromDomain(user);
      final json = dto.toJson();
      final fromJson = UserDto.fromFirestore(json).toDomain();

      expect(fromJson.id, user.id);
      expect(fromJson.email, user.email);
      expect(fromJson.displayName, user.displayName);
      expect(fromJson.photoUrl, user.photoUrl);
    });
  });
}
