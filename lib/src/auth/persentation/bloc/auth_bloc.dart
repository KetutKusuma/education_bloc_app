import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/update_user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
    required ForgotPassword forgotPassword,
  })  : _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        _forgotPassword = forgotPassword,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });

    on<SignInEvent>(_signInHandler);

    on<SignUpEvent>(_signUpHandler);

    on<UpdateUserEvent>(_updateUserHandler);

    on<ForgotPasswordEvent>(_forgotPasswordHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;
  final ForgotPassword _forgotPassword;
  final user = const LocalUser.empty();

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn.call(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) => emit(
        AuthError(
          l.errorMessage,
        ),
      ),
      (r) => emit(
        SignedIn(user),
      ),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    //
    final result = await _signUp.call(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) => emit(
        AuthError(
          l.errorMessage,
        ),
      ),
      (r) => emit(
        const SignedUp(),
      ),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser.call(
      UpdateUserParams(
        updateUserAction: event.updateUserAction,
        userData: event.userData,
      ),
    );

    result.fold(
      (l) => emit(AuthError(l.errorMessage)),
      (r) => emit(
        const UserUpdated(),
      ),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword.call(event.email);

    result.fold(
      (l) => emit(AuthError(l.errorMessage)),
      (r) => emit(const ForgotedPasswordSent()),
    );
  }
}
