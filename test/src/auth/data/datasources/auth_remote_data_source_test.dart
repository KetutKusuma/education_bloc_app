// import 'package:education_bloc_app/core/enums/update_user.dart';
// import 'package:education_bloc_app/src/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
// import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
// import 'package:mocktail/mocktail.dart';

// import 'auth_remote_data_source_test.mock.dart';

// void main() {
//   // Mock sign in with Google.
//   late MockFirebaseAuth authClient;
//   late MockFirebaseStorage dbClient;
//   late FakeFirebaseFirestore cloudStoreClient;
//   late AuthRemoteDataSource dataSource;
//   late AuthCredential credential;
//   late UserCredential userCredential;

//   setUp(() async {
//     authClient = MockFirebaseAuth();
//     cloudStoreClient = FakeFirebaseFirestore();
//     final googleSignIn = MockGoogleSignIn();
//     final signinAccount = await googleSignIn.signIn();
//     final googleAuth = await signinAccount!.authentication;
//     credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final mockuser = MockcUser();
//     userCredential = MockUserCredential(mockuser);

//     // Sign in.
//     final mockUser = MockUser(
//       uid: 'someuid',
//       email: 'bob@somedomain.com',
//       displayName: 'Bob',
//     );
//     authClient = MockFirebaseAuth(mockUser: mockUser);
//     final result = await authClient.signInWithCredential(credential);
//     final user = result.user;
//     // ignore: avoid_print
//     print('user : $user');

//     // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//     // ? ini kenapa ditaruh dibawah
//     // ? karena agar dbclientnya kosong lagi sepertinya (belum yakin)
//     // ? karena kalau dibuat diatas error jadi tes signupnya
//     // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//     dbClient = MockFirebaseStorage();
//     dataSource = AuthRemoteDataSourceImpl(
//       authClient: authClient,
//       cloudStoreClient: cloudStoreClient,
//       dbClient: dbClient,
//     );
//   });

//   const tPassword = 'test password';
//   const tFullName = 'test full name';
//   const tEmail = 'tstemail@gmail.com';

//   test('signUp', () async {
//     //
//     // act
//     await dataSource.signUp(
//       fullName: tFullName,
//       email: tEmail,
//       password: tPassword,
//     );

//     // expect that the user was created in the firestore and the
//     // auth client also this user
//     expect(authClient.currentUser, isNotNull);
//     expect(authClient.currentUser!.displayName, tFullName);

//     final user = await cloudStoreClient
//         .collection('users')
//         .doc(
//           authClient.currentUser!.uid,
//         )
//         .get();

//     expect(user.exists, isTrue);
//   });

//   group('signIn', () {
//     test('should complete successfully when call to the server is successful',
//         () async {
//       when(
//         () => authClient.signInWithEmailAndPassword(
//           email: any(named: 'email'),
//           password: any(named: 'password'),
//         ),
//       ).thenAnswer(
//         (invocation) async => userCredential,
//       );

//       when(
//         () => authClient.createUserWithEmailAndPassword(
//           email: 'email',
//           password: 'password',
//         ),
//       );

//       when(
//         () => authClient.currentUser!.updateDisplayName(any()),
//       ).thenAnswer(
//         (_) async => Future.value(),
//       );

//       when(
//         () => cloudStoreClient.collection(any()).doc().get(),
//       ).thenAnswer((invocation) async =>);

//       await dataSource.signUp(
//         fullName: tFullName,
//         email: 'newEmail@gmail.com',
//         password: tPassword,
//       );
//       // kenapa signout
//       // karena jika sudah signup maka data authclientnya
//       // sudah terisi dan expectnya ngecek dari signup
//       await authClient.signOut();
//       await dataSource.signIn(
//         email: 'newEmail@gmail.com',
//         password: tPassword,
//       );

//       expect(authClient.currentUser, isNotNull);
//       expect(authClient.currentUser!.email, 'newEmail@gmail.com');
//     });
//   });

//   group('updateUser', () {
//     test('displayName', () async {
//       //
//       await dataSource.signUp(
//         fullName: tFullName,
//         email: tEmail,
//         password: tPassword,
//       );
//       await dataSource.updateUser(
//         updateUserAction: UpdateUserAction.displayName,
//         userData: 'new name',
//       );

//       // assert
//       expect(
//         authClient.currentUser!.displayName,
//         'new name',
//       );
//     });

//     test('email', () async {
//       //
//       await dataSource.signUp(
//         fullName: tFullName,
//         email: tEmail,
//         password: tPassword,
//       );
//       await dataSource.updateUser(
//         updateUserAction: UpdateUserAction.email,
//         userData: 'newemail@gmail.com',
//       );

//       // assert
//       expect(
//         authClient.currentUser!.email,
//         'newemail@gmail.com',
//       );
//     });
//   });
// }
