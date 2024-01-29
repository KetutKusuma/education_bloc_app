// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

import 'package:education_bloc_app/core/usecases/usecases.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  SignUp(this._authRepo);

  final AuthRepo _authRepo;
  @override
  ResultFuture<void> call(SignUpParams params) {
    return _authRepo.signUp(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  const SignUpParams.empty()
      : this(
          email: '',
          fullName: '',
          password: '',
        );

  @override
  List<Object> get props => [fullName, email, password];
}
