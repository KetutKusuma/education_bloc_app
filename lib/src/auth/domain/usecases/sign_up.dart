// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_bloc_app/core/usecases/usecases.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

import 'package:education_bloc_app/core/enums/update_user.dart';

// class lala<kiri, kanan> -> kiri yg dikeluarkan, kanan yg dibutuhkan
class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  UpdateUser(this._authRepo);

  final AuthRepo _authRepo;

  @override
  ResultFuture<void> call(UpdateUserParams params) {
    // TODO: implement call
    return _authRepo.updateUser(
      updateUserAction: params.updateUserAction,
      userData: params.userData,
    );
  }
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.updateUserAction,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : this(
          updateUserAction: UpdateUserAction.displayName,
          userData: '',
        );

  final UpdateUserAction updateUserAction;
  final dynamic userData;

  @override
  List<dynamic> get props => [updateUserAction, userData];
}
