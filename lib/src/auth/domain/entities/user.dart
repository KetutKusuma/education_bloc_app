// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.points,
    this.groupId = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic,
    this.bio,
  });

  final String uid;
  final String email;
  final String fullName;
  final String? profilePic;
  final String? bio;
  final List<String> groupId;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;
  final int points;

  @override
  List<Object?> get props => [
        uid,
        email,
      ];

  factory LocalUser.emptyV2() {
    return const LocalUser(
      uid: '',
      email: '',
      fullName: '',
      // groupId: [],
      // enrolledCourseIds: [],
      // following: [],
      // followers: [],
      points: 0,
      profilePic: '',
      bio: '',
    );
  }

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
          groupId: const [],
          enrolledCourseIds: const [],
          followers: const [],
          following: const [],
          points: 0,
          profilePic: '',
          bio: '',
        );

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'LocalUser(uid: $uid, email: $email, fullName: $fullName, '
        'profilePic: $profilePic, bio: $bio, groupId: $groupId, '
        'enrolledCourseIds: $enrolledCourseIds, following: $following, '
        'followers: $followers)';
  }
}
