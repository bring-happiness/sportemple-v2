import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../_extensions/string_extension.dart';

import '../arguments/synchronize_user_arguments.dart';
import '../arguments/synchronize_user_finished_arguments.dart';
import '../../user/screens/synchronize_user_finished_screen.dart';

class SynchronizeUserScreen extends StatefulWidget {
  static const String routeName = '/synchronize-user';
  final SynchronizeUserArguments arguments;

  const SynchronizeUserScreen({Key key, this.arguments}) : super(key: key);

  @override
  _SynchronizeUserScreenState createState() => _SynchronizeUserScreenState();
}

class _SynchronizeUserScreenState extends State<SynchronizeUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isGettingInfos = true;

  @override
  void initState() {
    super.initState();

    _getInfos();
  }

  void _getInfos() async {
    setState(() {
      _isGettingInfos = true;
    });

    http.get('${DotEnv().env['SPORTEMPLE_API']}/users/infos', headers: {
      'club_id': '57920066',
      'username': widget.arguments.username.btoa(),
      'password': widget.arguments.password.btoa(),
    }).then((response) {
      setState(() {
        _isGettingInfos = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        Navigator.of(context)
            .pushReplacementNamed(SynchronizeUserFinishedScreen.routeName,
                arguments: SynchronizeUserFinishedArguments(
                  username: widget.arguments.username,
                  password: widget.arguments.password,
                  civility: data['civility'],
                  firstname: data['firstname'],
                  lastname: data['lastname'],
                  birthdate: data['birthdate'],
                  license: data['license'],
                  ranking: data['ranking'],
                  partners: data['partners'],
                ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(days: 365),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'La suppression a échoué. Veuillez réessayer',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  'RÉESSAYER',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _getInfos();
                },
              )
            ],
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Clichy Tennis'),
      ),
      body: !_isGettingInfos ? Container() : SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: const EdgeInsets.all(27.0),
                child: const CircularProgressIndicator(),
              ),
              const Text(
                'Récupération des données en cours...',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
