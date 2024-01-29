import 'package:education_bloc_app/core/usecases/usecases.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._authRepo);

  final AuthRepo _authRepo;
  @override
  ResultFuture<void> call(String params) {
    return _authRepo.forgotPassword(params);
  }
}
