import '../../infrastructure/repository_impl/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

class UpdateProfileUsecase {
  final UserRepositoryImpl repo;

  UpdateProfileUsecase(this.repo);

  Future<UserEntity?> updateEmail(String email) => repo.updateEmail(email);

  Future<bool> updatePassword(String password) => repo.updatePassword(password);
}
