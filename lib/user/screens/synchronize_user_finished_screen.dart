import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../arguments/synchronize_user_finished_arguments.dart';
import '../../booking/screens/booking_home_screen.dart';
import '../../partner/widgets/partner_widget.dart';
import '../widgets/user_ranking.dart';

class SynchronizeUserFinishedScreen extends StatefulWidget {
  static const String routeName = '/synchronize/finished';

  @override
  _SynchronizeUserFinishedScreenState createState() =>
      _SynchronizeUserFinishedScreenState();
}

class _SynchronizeUserFinishedScreenState
    extends State<SynchronizeUserFinishedScreen> {
  IO.Socket _socket;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _socket = IO.io(DotEnv().env['SPORTEMPLE_API'], <String, dynamic>{
      'transports': ['websocket'],
    });
  }

  void _onValidatePressed(arguments) async {
    _socket.emit('save-user-infos', {
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
    Navigator.of(context)
        .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final SynchronizeUserFinishedArguments arguments =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('C.S Clichy Tennis'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onValidatePressed(arguments),
        label: const Text('VALIDER'),
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
                    UserRanking(
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
                      return PartnerWidget(
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
    );
  }
}
