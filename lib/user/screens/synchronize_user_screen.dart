import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../arguments/synchronize_user_arguments.dart';
import '../arguments/synchronize_user_finished_arguments.dart';
import '../../user/screens/synchronize_user_finished_screen.dart';

class SynchronizeUserScreen extends StatefulWidget {
  static const String routeName = '/synchronize-user';

  @override
  _SynchronizeUserScreenState createState() => _SynchronizeUserScreenState();
}

class _SynchronizeUserScreenState extends State<SynchronizeUserScreen> {
  IO.Socket socket;

  @override
  void initState() {
    super.initState();

    socket = IO.io(DotEnv().env['SPORTEMPLE_API'], <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('login-sync-infos-finished', (data) {
      print('login sync infos finished');

      final SynchronizeUserArguments arguments = ModalRoute.of(context).settings.arguments;

      Navigator.of(context).pushReplacementNamed(SynchronizeUserFinishedScreen.routeName,
          arguments: SynchronizeUserFinishedArguments(
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
        title: const Text('C.S Clichy Tennis'),
      ),
      body: SafeArea(
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
