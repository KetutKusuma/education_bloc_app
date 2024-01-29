// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.groupId,
    required this.enrolledCourseId,
    required this.following,
    required this.followers,
    required this.points,
    this.profilePic,
    this.bio,
  });

  final String uid;
  final String email;
  final String fullName;
  final String? profilePic;
  final String? bio;
  final List<String> groupId;
  final List<String> enrolledCourseId;
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
      groupId: [],
      enrolledCourseId: [],
      following: [],
      followers: [],
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
          enrolledCourseId: const [],
          followers: const [],
          following: const [],
          points: 0,
          profilePic: '',
          bio: '',
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'profilePic': profilePic,
      'bio': bio,
      'groupId': groupId,
      'enrolledCourseId': enrolledCourseId,
      'following': following,
      'followers': followers,
      'points': points,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      groupId: List<String>.from(map['groupId'] as List<String>),
      enrolledCourseId: List<String>.from(
        map['enrolledCourseId'] as List<String>,
      ),
      following: List<String>.from(map['following'] as List<String>),
      followers: List<String>.from(map['followers'] as List<String>),
      points: map['points'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalUser.fromJson(String source) =>
      LocalUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'LocalUser(uid: $uid, email: $email, fullName: $fullName, '
        'profilePic: $profilePic, bio: $bio, groupId: $groupId, '
        'enrolledCourseId: $enrolledCourseId, following: $following, '
        'followers: $followers)';
  }
}
