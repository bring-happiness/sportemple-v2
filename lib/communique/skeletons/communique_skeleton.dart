import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CommuniqueSkeleton extends StatelessWidget {
  final double width;

  const CommuniqueSkeleton({Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonAnimation(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300]
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        SkeletonAnimation(
          child: Container(
            width: this.width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
}
