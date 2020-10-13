import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sportemple/widgets/partner_widget.dart';

import '../arguments/synchronize_finished_arguments.dart';
import './booking_home_screen.dart';

class SynchronizeFinishedScreen extends StatefulWidget {
  static const String routeName = '/synchronize-data/finished';

  @override
  _SynchronizeFinishedScreenState createState() =>
      _SynchronizeFinishedScreenState();
}

class _SynchronizeFinishedScreenState extends State<SynchronizeFinishedScreen> {
  IO.Socket socket;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    socket = IO.io(DotEnv().env['SPORTEMPLE_API'], <String, dynamic>{
      'transports': ['websocket'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final SynchronizeFinishedArguments arguments =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          socket.emit('save-user-infos', {
            'username': arguments.user.username,
            'password': arguments.user.password,
            'civility': arguments.user.civility,
            'firstname': arguments.user.firstname,
            'lastname': arguments.user.lastname,
            'birthdate': arguments.user.birthdate,
            'license': arguments.user.license,
            'ranking': arguments.user.ranking,
            'partners': arguments.user.partners,
          });

          final SharedPreferences prefs = await _prefs;
          prefs.setString('username', arguments.user.username);
          prefs.setString('password', arguments.user.password);

          Route route = MaterialPageRoute(builder: (context) => BookingHomeScreen());
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        },
        label: Text('VALIDER'),
        icon: Icon(Icons.check),
      ),
      body: SafeArea(
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
                    style: TextStyle(fontSize: 17, color: Colors.blueGrey),
                  ),
                  Text(
                    arguments.user.license,
                    style: TextStyle(fontSize: 17, color: Colors.blueGrey),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(47),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Classé ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          arguments.user.ranking,
                          style:
                              TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
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
                          child: Text(
                            'Partenaires',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    ...arguments.user.partners.map((partner) {
                      return PartnerWidget(
                        partner: partner,
                        profileAssetName: arguments.user.profileAssetName,
                      );
                    }).toList()
                  ],
                ),
              ),
              SizedBox(
                height: 85,
              )
            ],
          ),
        ),
      ),
    );
  }
}
