import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../_extensions/string_extension.dart';

import '../../user/arguments/synchronize_user_arguments.dart';
import '../../booking/screens/booking_home_screen.dart';
import '../../user/screens/synchronize_user_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _usernameInput = TextEditingController();
  final _passwordInput = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
// todo: must be on InitalScreen
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String username = prefs.getString('username');
      String password = prefs.getString('password');

      if (username == null || password == null) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
    });
  }

  void _onSubmitted(BuildContext context) async {
    setState(() {
      _isConnecting = true;
    });

    final username = _usernameInput.text;
    final password = _passwordInput.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      _showConnectingSnackbar(context);

      final response =
          await http.post('${DotEnv().env['SPORTEMPLE_API']}/login', headers: {
        'club_id': '57920066',
        'username': username.btoa(),
        'password': password.btoa(),
      });

      Scaffold.of(context).hideCurrentSnackBar();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['first_login']) {
          _onFirstLogin();
        } else {
          _onNormalLogin();
        }
      } else if (response.statusCode == 401) {
        _onLoginFailed(context);
      }
    }

    setState(() {
      _isConnecting = false;
    });
  }

  void _onFirstLogin() {
    setState(() {
      _isConnecting = false;

      Navigator.of(context).pushReplacementNamed(
        SynchronizeUserScreen.routeName,
        arguments: SynchronizeUserArguments(
            username: _usernameInput.text, password: _passwordInput.text),
      );
    });
  }

  void _onNormalLogin() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('username', _usernameInput.text);
    prefs.setString('password', _passwordInput.text);

    Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
  }

  void _showConnectingSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(days: 365),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Connexion...',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _onLoginFailed(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red[300],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Identifiant ou mot de passe incorrect',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isConnecting,
        child: Builder(
          builder: (_context) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: const AssetImage('assets/images/tennis-jungle.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: _usernameInput,
                          decoration: const InputDecoration(
                            hintText: 'Identifiant ADSL',
                            helperText: '6 caractères. Ex: "aldupo"',
                            helperStyle: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          onSubmitted: (_) => _onSubmitted(_context),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: _passwordInput,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Mot de passe',
                              helperStyle: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              fillColor: Colors.white,
                              filled: true),
                          onSubmitted: (_) => _onSubmitted(_context),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        child: RaisedButton(
                          onPressed: () => _onSubmitted(_context),
                          child: const Text('Connexion'),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
