import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BookingHomeScreen extends StatefulWidget {
  static const String routeName = '/booking/home';

  @override
  _BookingHomeScreenState createState() => _BookingHomeScreenState();
}

class _BookingHomeScreenState extends State<BookingHomeScreen> {
  IO.Socket socket;
  String username;
  String password;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        username = prefs.getString('username');
        password = prefs.getString('password');
      });
    });

    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('', (data) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Center(
          child: Text('ACCUEIL $username $password')
        ),
      ),
    );
  }
}
