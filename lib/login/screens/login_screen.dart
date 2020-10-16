import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  IO.Socket _socket;
  final _usernameInput = TextEditingController();
  final _passwordInput = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String username = prefs.getString('username');
      String password = prefs.getString('password');

      if (username == null || password == null) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
    });

    _socket = IO.io(DotEnv().env['SPORTEMPLE_API'], <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('connect', (_) {
      print('connect');
    });

    _socket.on('login-success', (success) async {
      if (!success) {
        //todo: show error message
        return;
      }

      final SharedPreferences prefs = await _prefs;
      prefs.setString('username', _usernameInput.text);
      prefs.setString('password', _passwordInput.text);

      Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
    });

    _socket.on('first-login-success', (success) {
      print('first-login-success $success');
    });

    _socket.on('login-sync-infos', (_) {
      print('login-sync-infos');

      setState(() {
        _isConnecting = false;

        Navigator.of(context).pushReplacementNamed(
          SynchronizeUserScreen.routeName,
          arguments: SynchronizeUserArguments(
              username: _usernameInput.text, password: _passwordInput.text),
        );
      });
    });
  }

  void _onSubmitted() {
    setState(() {
      _isConnecting = true;
    });

    final username = _usernameInput.text;
    final password = _passwordInput.text;

    if (username.isEmpty || password.isEmpty) {
      return;
    }

    _socket.emit('login', {
      'clubId': 57920066,
      'username': username,
      'password': password,
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isConnecting,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: const DecorationImage(
                image: const AssetImage('assets/images/tennis-jungle.jpg'),
                fit: BoxFit.cover),
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
                          helperStyle:
                              const TextStyle(color: Colors.white, fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onSubmitted: (_) => _onSubmitted,
                      ),
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
                        onSubmitted: (_) => _onSubmitted,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: screenWidth * 0.8,
                      child: RaisedButton(
                        onPressed: _onSubmitted,
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
    );
  }
}
