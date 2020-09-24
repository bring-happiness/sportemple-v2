import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sportemple/arguments/login_arguments.dart';
import 'package:sportemple/screens/booking_home_screen.dart';
import 'package:sportemple/screens/synchronize_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  IO.Socket socket;
  final usernameInput = TextEditingController();
  final passwordInput = TextEditingController();

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

    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('connect');
    });

    socket.on('login-success', (success) async {
      if (!success) {
        //todo: show error message
        return;
      }

      final SharedPreferences prefs = await _prefs;
      prefs.setString('username', usernameInput.text);
      prefs.setString('password', passwordInput.text);

      Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
    });

    socket.on('first-login-success', (success) {
      print('first-login-success $success');
    });

    socket.on('login-sync-infos', (_) {
      print('login-sync-infos');
      Navigator.of(context).pushNamed(SynchronizeScreen.routeName,
          arguments: LoginArguments(
              username: usernameInput.text, password: passwordInput.text));
    });
  }

  void _onSubmitted() {
    final username = usernameInput.text;
    final password = passwordInput.text;

    if (username.isEmpty || password.isEmpty) {
      return;
    }

    socket.emit('login', {
      'clubId': 57920066,
      'username': username,
      'password': password,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/tennis-jungle.jpg'),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            height: 300,
            width: 350,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: usernameInput,
                      decoration: InputDecoration(
                        hintText: 'Identifiant ADSL',
                        helperText: '6 caractères. Ex: "aldupo"',
                        helperStyle:
                            TextStyle(color: Colors.white, fontSize: 14),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onSubmitted: (_) => _onSubmitted,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller: passwordInput,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          helperText: '4 caractères',
                          helperStyle:
                              TextStyle(color: Colors.white, fontSize: 14),
                          fillColor: Colors.white,
                          filled: true),
                      onSubmitted: (_) => _onSubmitted,
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Container(
                      width: 350,
                      child: RaisedButton(
                        onPressed: _onSubmitted,
                        child: Text('Connexion'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
