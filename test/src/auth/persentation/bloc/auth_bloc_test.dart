import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/core/errors/failures.dart';
import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_bloc_app/src/auth/persentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  // const tPassword = 'password';
  // const tEmail = 'email';
  // const tfullName = 'fullName';
  // const tUpdateUser = UpdateUserAction.displayName;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      updateUser: updateUser,
      forgotPassword: forgotPassword,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('initialState should be [AuthInitial]', () {
    //
    expect(
      authBloc.state,
      const AuthInitial(),
    );
  });

  group('SignInEvent', () {
    const tUser = LocalUser.empty();
    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading, SignedIn] when [SignInEvent] is added',
      build: () {
        when(
          () => signIn.call(any()),
        ).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        SignedIn(
          tUser,
        ),
      ],
      verify: (_) {
        verify(
          () => signIn.call(tSignInParams),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading, AuthError] '
      'when [SignInEvent] is unsuccessful',
      build: () {
        when(
          () => signIn.call(any()),
        ).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => <AuthState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signIn.call(tSignInParams),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    //
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, SignedUp] when [SignUpEvent] is added.',
      build: () {
        when(
          () => signUp.call(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          fullName: tSignUpParams.fullName,
          password: tSignUpParams.password,
        ),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        SignedUp(),
      ],
      verify: (_) {
        verify(
          () => signUp.call(tSignUpParams),
        ).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when [SignUpEvent] is added.',
      build: () {
        // arrange
        when(
          () => signUp.call(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          fullName: tSignUpParams.fullName,
          password: tSignUpParams.password,
        ),
      ),
      expect: () => <AuthState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signUp.call(tSignUpParams),
        ).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('UpdateUser', () {
    //
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, UserUpdated] when [UpdateUserEvent] is added.',
      build: () {
        when(
          () => updateUser.call(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          updateUserAction: UpdateUserAction.displayName,
          userData: 'uhuy',
        ),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        UserUpdated(),
      ],
      verify: (_) {
        verify(
          () => updateUser.call(
            const UpdateUserParams(
                updateUserAction: UpdateUserAction.displayName,
                userData: 'uhuy'),
          ),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when [UpdateUserEvent] is fail.',
      build: () {
        when(
          () => updateUser.call(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          updateUserAction: UpdateUserAction.displayName,
          userData: 'uhuy',
        ),
      ),
      expect: () => <AuthState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => updateUser.call(
            UpdateUserParams(
              updateUserAction: tUpdateUserParams.updateUserAction,
              userData: tUpdateUserParams.userData,
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });

  group('ForgotPassword', () {
    //

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, ForgotedPasswordSent] '
      'when [ForgotPasswordEvent] is added.',
      build: () {
        when(
          () => forgotPassword.call(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent(email: 'email')),
      expect: () => const <AuthState>[
        AuthLoading(),
        ForgotedPasswordSent(),
      ],
      verify: (_) {
        //
        verify(
          () => forgotPassword.call('email'),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] '
      'when [ForgotPasswordEvent] is failed.',
      build: () {
        when(
          () => forgotPassword.call(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent(email: 'email')),
      expect: () => <AuthState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        //
        verify(
          () => forgotPassword.call('email'),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });
}
