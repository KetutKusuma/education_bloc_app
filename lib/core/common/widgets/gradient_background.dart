import 'package:flutter/material.dart';

class GradientBackgroundWidget extends StatelessWidget {
  const GradientBackgroundWidget({
    required this.image,
    required this.child,
    super.key,
  });

  final String image;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
        ),
      ),
      child: child,
    );
  }
}
