import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportemple/connectivity/widgets/connectivity_widget.dart';
import '../../_extensions/string_extension.dart';
import 'package:http/http.dart' as http;

import '../arguments/synchronize_user_finished_arguments.dart';
import '../../booking/screens/booking_home_screen.dart';
import '../widgets/user_list_item_widget.dart';
import '../widgets/user_ranking_widget.dart';

class SynchronizeUserFinishedScreen extends StatefulWidget {
  static const String routeName = '/synchronize/finished';

  @override
  _SynchronizeUserFinishedScreenState createState() =>
      _SynchronizeUserFinishedScreenState();
}

class _SynchronizeUserFinishedScreenState
    extends State<SynchronizeUserFinishedScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isSavingUserInfos = false;

  void _onValidatePressed(SynchronizeUserFinishedArguments arguments) async {
    setState(() {
      _isSavingUserInfos = true;
    });

    final response =
        await http.post('${DotEnv().env['SPORTEMPLE_API']}/users/infos', body: {
      'username': arguments.user.username.btoa(),
      'password': arguments.user.password.btoa(),
      'civility': arguments.user.civility,
      'firstname': arguments.user.firstname,
      'lastname': arguments.user.lastname,
      'birthdate': arguments.user.birthdate,
      'license': arguments.user.license,
      'ranking': arguments.user.ranking,
      'partners': json.encode(arguments.user.partners),
    });

    setState(() {
      _isSavingUserInfos = false;
    });

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await _prefs;
      prefs.setString('username', arguments.user.username.btoa());
      prefs.setString('password', arguments.user.password.btoa());

      Route route =
      MaterialPageRoute(builder: (context) => BookingHomeScreen());
      Navigator.of(context)
          .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SynchronizeUserFinishedArguments arguments =
        ModalRoute.of(context).settings.arguments;
    final String title = 'Clichy Tennis';

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        middle: Text(title),
      )
          : AppBar(
        title: Text(title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: FloatingActionButton.extended(
          onPressed: () => _onValidatePressed(arguments),
          label: const Text('VALIDER'),
          icon: Icon(Icons.check),
        ),
      ),
      body: ConnectivityWidget(
        child: ModalProgressHUD(
          inAsyncCall: _isSavingUserInfos,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 37.0),
                    child: Container(
                      height: 115,
                      child: SvgPicture.asset(arguments.user.profileAssetName),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Text(
                      '${arguments.user.firstname} ${arguments.user.lastname}',
                      style: TextStyle(
                          fontSize: 23, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${arguments.user.age} ans',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.blueGrey),
                      ),
                      Text(
                        arguments.user.license,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.blueGrey),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(47),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Classé ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        UserRankingWidget(
                          ranking: arguments.user.ranking,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                'Partenaires',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        ...arguments.user.partners.map((partner) {
                          return UserListItemWidget(
                            partner: partner,
                            profileAssetName: arguments.user.profileAssetName,
                          );
                        }).toList()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 85,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
