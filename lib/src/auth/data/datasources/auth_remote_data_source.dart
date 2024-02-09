// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/core/errors/exception.dart';
import 'package:education_bloc_app/core/utils/constants.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

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

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      // upload the user
      await _setUserData(user, email);

      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // isi data user displayname dan photo url
      await userCred.user!.updateDisplayName(fullName);
      await userCred.user!.updatePhotoURL(kDefaultAvatar);
      // set lagi user data
      await _setUserData(_authClient.currentUser!, email);
      log('sukses signup ?');
    } on FirebaseException catch (e) {
      log('masuk firebase excep : $e');
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      log('masuk exception catch : $e');
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction updateUserAction,
    dynamic userData,
  }) async {
    try {
      switch (updateUserAction) {
        case UpdateUserAction.email:
          await _authClient.currentUser!.updateEmail(userData as String);
          await _updateUserData({
            'email': userData,
          });
        case UpdateUserAction.displayName:
          await _authClient.currentUser!.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});

        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser!.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser!.updatePhotoURL(url);
          await _updateUserData({'profilePicture': url});
        case UpdateUserAction.password:
          if (_authClient.currentUser!.email == null) {
            throw const ServerException(
              message: 'User is not exist',
              statusCode: 'Insufficient Permssion',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );

          await _authClient.currentUser!.updatePassword(
            newData['newPassword'] as String,
          );
        case UpdateUserAction.bio:
          await _updateUserData(
            {
              'bio': userData as String,
            },
          );
        default:
        // throw
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            points: 0,
            profilePic: user.photoURL ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap dataMap) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser!.uid)
        .update(dataMap);
  }
}
