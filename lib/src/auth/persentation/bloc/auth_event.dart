part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<dynamic> get props => [];
}

class SignInEvent extends AuthEvent {
  const SignInEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent(
      {required this.email, required this.fullName, required this.password});

  final String email;
  final String fullName;
  final String password;

  @override
  // TODO: implement props
  List<Object> get props => [email, fullName, password];
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.updateUserAction,
    required this.userData,
  }) : assert(
          userData is String || userData is File,
          '[userData] must be either a String or a File, '
          'but was ${userData.runtimeType}',
        );

  final UpdateUserAction updateUserAction;
  final dynamic userData;

  @override
  List<dynamic> get props => [
        updateUserAction,
        userData,
      ];
}
