// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_bloc_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: 'Brand new curriculum',
          description: 'This is the first online education platform designed '
              "by the world's",
        );

  const PageContent.second()
      : this(
          image: MediaRes.casualLife,
          title: 'Brand a fun atmosphere',
          description: 'This is the first online education platform designed '
              "by the world's",
        );

  const PageContent.third()
      : this(
          image: MediaRes.casualMediationScience,
          title: 'Easy to join the lesson',
          description: 'This is the first online education platform designed '
              "by the world's",
        );

  @override
  List<Object?> get props => [
        image,
        title,
        description,
      ];
}
