import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportemple/user/widgets/user_ranking_widget.dart';
import '../models/user.dart';

class UserProfileWidget extends StatelessWidget {
  final User user;

  const UserProfileWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Card(
              elevation: 3,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 11.0),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null ? user.firstname : '',
                        style: TextStyle(
                            fontSize: 17,
                            color:
                            Theme.of(context).primaryColor),
                      ),
                      Text(
                        user != null ? user.lastname : '',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.blueGrey),
                      )
                    ],
                  ),
                  trailing: UserRankingWidget(
                    ranking: user?.ranking,
                  )
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 100,
              width: 100,
              child: user != null
                  ? SvgPicture.asset(user.profileAssetName)
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
