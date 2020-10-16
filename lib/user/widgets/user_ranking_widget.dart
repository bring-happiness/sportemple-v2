import 'package:flutter/material.dart';

class UserRankingWidget extends StatelessWidget {
  final String ranking;

  const UserRankingWidget({this.ranking});

  String get _ranking {
    return ranking != null ? ranking : ' ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: FittedBox(
            child: Text(
              this._ranking,
              style:
              const TextStyle(color: Colors.white, fontSize: 23),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor),
    );
  }
}
