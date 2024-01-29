// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_bloc_app/core/usecases/usecases.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

// ! important
// * UsecaseWithParams<LocalUser, SignInParams>
// * LocalUser -> ini adalah yg mau dibalikin (left)
// * SignInParams -> ini adalah yg dibutuhkan (right)
// ! important
class SignIn extends UsecaseWithParams<LocalUser, SignInParams> {
  SignIn({required AuthRepo authRepo}) : _authRepo = authRepo;

  final AuthRepo _authRepo;

  @override
  ResultFuture<LocalUser> call(SignInParams params) {
    return _authRepo.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  const SignInParams.empty() : this(email: '', password: '');

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
