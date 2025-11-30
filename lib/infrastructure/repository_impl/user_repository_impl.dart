import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

class UserRepositoryImpl {
  final client = Supabase.instance.client;

  Future<UserEntity?> updateEmail(String newEmail) async {
    final res = await client.auth.updateUser(UserAttributes(email: newEmail));

    if (res.user == null) return null;

    return UserEntity(
      id: res.user!.id,
      email: res.user!.email ?? "",
    );
  }

  Future<bool> updatePassword(String newPassword) async {
    final res = await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    return res.user != null;
  }
}
