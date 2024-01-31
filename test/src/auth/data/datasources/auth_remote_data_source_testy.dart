import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_bloc_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFireStore extends Mock implements FirebaseFirestore {}

// ini dibuat untuk dapat data user buatan
// karena pada auth signIn perlu membalikan data user jadi
// ? [MockUser]
// digunakan untuk menggantikan user
class MockUser extends Mock implements User {
  final String _uid = 'uid';

  @override
  String get uid => _uid;
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

void main() {
  late FirebaseAuth firebaseAuth;
  late FirebaseStorage firebaseStorage;
  late FirebaseFirestore firestore;
  late AuthRemoteDataSource remoteDataSource;
  late UserCredential userCred;
  final mockUser = MockUser();

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    firebaseStorage = MockFirebaseStorage();
    firestore = MockFirebaseFireStore();
    userCred = MockUserCredential(mockUser);
    remoteDataSource = AuthRemoteDataSourceImpl(
      authClient: firebaseAuth,
      cloudStoreClient: firestore,
      dbClient: firebaseStorage,
    );
  });

  group(
    'SignIn',
    () {
      test(
        'should complete succesfully when the call to server is successful',
        () async {
          when(
            () => firebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => userCred,
          );

          // when(() => firebaseAuth.createUserWithEmailAndPassword(email: email, password: password),)

          await remoteDataSource.signUp(
            fullName: 'fullName',
            email: 'email',
            password: 'password',
          );

          // act
          final result = await remoteDataSource.signIn(
            email: 'email',
            password: 'password',
          );

          // assert
          expect(result.email, equals('email'));
          verify(
            () => remoteDataSource.signIn(email: 'email', password: 'password'),
          ).called(1);
          verifyNoMoreInteractions(firebaseAuth);
        },
      );
    },
  );
}
