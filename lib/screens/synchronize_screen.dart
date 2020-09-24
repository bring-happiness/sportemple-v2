import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sportemple/arguments/login_arguments.dart';
import 'package:sportemple/arguments/synchronize_finished_arguments.dart';
import 'package:sportemple/screens/synchronize_finished_screen.dart';

class SynchronizeScreen extends StatefulWidget {
  static const String routeName = '/synchronize-data';

  @override
  _SynchronizeScreenState createState() => _SynchronizeScreenState();
}

class _SynchronizeScreenState extends State<SynchronizeScreen> {
  IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('login-sync-infos-finished', (data) {
      print('login sync infos finished');

      final LoginArguments arguments = ModalRoute.of(context).settings.arguments;

      Navigator.of(context).pushNamed(SynchronizeFinishedScreen.routeName,
          arguments: SynchronizeFinishedArguments(
            username: arguments.username,
            password: arguments.password,
            civility: data['civility'],
            firstname: data['firstname'],
            lastname: data['lastname'],
            birthdate: data['birthdate'],
            license: data['license'],
            ranking: data['ranking'],
            partners: data['partners'],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(27.0),
                child: CircularProgressIndicator(),
              ),
              Text(
                'Récupération des données en cours...',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
