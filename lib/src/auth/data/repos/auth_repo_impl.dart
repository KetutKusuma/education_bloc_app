import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/core/errors/exception.dart';
import 'package:education_bloc_app/core/errors/failures.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log("MASUK SIGN IN");
      final result = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      log("error : $e");
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  ResultFuture<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction updateUserAction,
    required dynamic userData,
  }) async {
    try {
      await _remoteDataSource.updateUser(
        updateUserAction: updateUserAction,
        userData: userData,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }
}
