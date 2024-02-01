import 'package:education_bloc_app/core/enums/update_user.dart';
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

  const tPassword = 'password';
  const tEmail = 'email';
  const tfullName = 'fullName';
  const tUpdateUser = UpdateUserAction.displayName;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

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

  tearDown(() => authBloc.close());
}
