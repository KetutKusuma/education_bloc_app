import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> updateUser({
    required UpdateUserAction updateUserAction,
    required dynamic userData,
  });
}
