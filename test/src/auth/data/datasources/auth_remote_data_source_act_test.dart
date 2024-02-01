import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/core/errors/exception.dart';
import 'package:education_bloc_app/core/utils/constants.dart';
import 'package:education_bloc_app/core/utils/typedef.dart';
import 'package:education_bloc_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// class MockFirebaseStorage extends Mock implements FirebaseStorage {}
// class MockFirebaseFireStore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// ini dibuat untuk dapat data user buatan
// karena pada auth signIn perlu membalikan data user jadi
// ? [MockUser]
// digunakan untuk menggantikan user
class MockUser extends Mock implements User {
  String _uid = 'uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {
  //
}

void main() {
  late FirebaseAuth firebaseAuth;
  late MockFirebaseStorage firebaseStorage;
  late FirebaseFirestore firestore;
  late AuthRemoteDataSource remoteDataSource;
  late UserCredential userCred;
  late MockUser mockUser;
  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUp(() async {
    firebaseAuth = MockFirebaseAuth();
    firebaseStorage = MockFirebaseStorage();
    firestore = FakeFirebaseFirestore();
    // ini untuk mendaftarkan satu data user
    documentReference = firestore.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    mockUser = MockUser()..uid = documentReference.id;
    userCred = MockUserCredential(mockUser);
    remoteDataSource = AuthRemoteDataSourceImpl(
      authClient: firebaseAuth,
      cloudStoreClient: firestore,
      dbClient: firebaseStorage,
    );

    when(
      () => firebaseAuth.currentUser,
    ).thenReturn(mockUser);
  });

  const tPassword = 'test password';
  const tFullName = 'test full name';
  const tEmail = 'test email';

  final tFirebaseAuthException = FirebaseException(
    plugin: 'uhuy',
    code: 'user-not-found',
    message: 'There is not user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('forgotPassword', () {
    //
    test('should complete successfully when no [Exception] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final call = remoteDataSource.forgotPassword(tEmail);

      expect(call, completes);

      verify(
        () => firebaseAuth.sendPasswordResetEmail(
          email: tEmail,
        ),
      ).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
    test(
        'should thrown [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      ).thenThrow(
        tFirebaseAuthException,
      );

      final call = remoteDataSource.forgotPassword;

      expect(() => call(tEmail), throwsA(isA<ServerException>()));
      verify(
        () => firebaseAuth.sendPasswordResetEmail(
          email: tEmail,
        ),
      ).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
  });
  group('signIn', () {
    //
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        return userCred;
      });

      final result =
          await remoteDataSource.signIn(email: tEmail, password: tPassword);

      expect(
        result.uid,
        userCred.user!.uid,
      );
      expect(result.points, 0);
      verify(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });

    test('should throw [ServerException] when user is null after signing in',
        () async {
      //
      final emptyUserCred = MockUserCredential();
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => emptyUserCred,
      );

      // act
      final call = remoteDataSource.signIn;

      expect(
        () => call(
          email: 'email',
          password: 'password',
        ),
        throwsA(
          isA<ServerException>(),
        ),
      );
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = remoteDataSource.signIn;
      expect(
        () => call(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(
          isA<ServerException>(),
        ),
      );

      verify(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
  });

  group('signUp', () {
    //

    test('should complete successfully when no [Exception] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => userCred,
      );
      // kenapa perlu update display name
      // karena ketika signup memasukan fullname, password dan email
      // karena createUser hanya memakai password dan email
      when(
        () => userCred.user!.updateDisplayName(
          any(),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      /// kenapa harus update photoURL
      /// karena secara default foto di insert ketika signUp
      when(
        () => userCred.user!.updatePhotoURL(any()),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final call = remoteDataSource.signUp(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
      );

      //expect completes
      // artinya ekspetasi kode akan berjalan terus
      expect(
        call,
        completes,
      );
      verify(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      /// ini membuat fungsi menunggu hingga dipanggil
      /// karena variabel call diatas
      /// tidak bisa menggunakan asynchronous (await)
      await untilCalled(
        () => userCred.user!.updateDisplayName(any()),
      );
      await untilCalled(
        () => userCred.user!.updatePhotoURL(any()),
      );

      /// verify semua arrange (when(()=> blablabla))
      verify(
        () => userCred.user!.updateDisplayName(
          tFullName,
        ),
      ).called(1);
      verify(
        () => userCred.user!.updatePhotoURL(kDefaultAvatar),
      ).called(1);

      verifyNoMoreInteractions(firebaseAuth);
    });
    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      //
      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = remoteDataSource.signUp;
      expect(
        () => call(
          fullName: tFullName,
          email: tEmail,
          password: tPassword,
        ),
        throwsA(
          isA<ServerException>(),
        ),
      );

      verify(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
      when(
        () => firebaseAuth.currentUser,
      ).thenReturn(mockUser);
    });
    test('should update user displayName when no [Exception] is thrown',
        () async {
      // arrange
      when(() => mockUser.updateDisplayName(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await remoteDataSource.updateUser(
        updateUserAction: UpdateUserAction.displayName,
        userData: tFullName,
      );

      verify(() => mockUser.updateDisplayName(tFullName)).called(1);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));

      final userData =
          await firestore.collection('users').doc(mockUser.uid).get();

      expect(userData.data()!['fullName'], tFullName);
      verifyNoMoreInteractions(mockUser);
    });
    test('should update user email when no [Exception] is thrown', () async {
      // arrange
      when(() => mockUser.updateEmail(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await remoteDataSource.updateUser(
        updateUserAction: UpdateUserAction.email,
        userData: tEmail,
      );

      verify(() => mockUser.updateEmail(tEmail)).called(1);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));

      final userData =
          await firestore.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['email'], tEmail);
      verifyNoMoreInteractions(mockUser);
    });

    test('should update user bio when no [Exception] is thrown', () async {
      // arrange
      const newBio = 'new bio';

      await remoteDataSource.updateUser(
        updateUserAction: UpdateUserAction.bio,
        userData: newBio,
      );

      final userData =
          await firestore.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['bio'], newBio);

      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNoMoreInteractions(mockUser);
    });

    test('should update user password when no [Exception] is thrown', () async {
      // arrange
      when(
        () => mockUser.updatePassword(tPassword),
      ).thenAnswer(
        (_) async => Future.value(),
      );
      when(
        () => mockUser.email,
      ).thenReturn(tEmail);

      when(() => mockUser.reauthenticateWithCredential(any())).thenAnswer(
        (_) async => userCred,
      );

      await remoteDataSource.updateUser(
        updateUserAction: UpdateUserAction.password,
        userData: jsonEncode({
          'oldPassword': 'oldPassword',
          'newPassword': tPassword,
        }),
      );
      verify(
        () => mockUser.updatePassword(tPassword),
      );

      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      final userData =
          await firestore.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['password'], null);
    });

    test(
      'should update user profilePic successfully when no [Exception] is thrown',
      () async {
        final newProfilePic = File(
          'assets/images/default_user.png',
        );

        when(
          () => mockUser.updatePhotoURL(
            any(),
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        );

        await remoteDataSource.updateUser(
          updateUserAction: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        verify(
          () => mockUser.updatePhotoURL(any()),
        ).called(1);
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));

        expect(firebaseStorage.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
