import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sportemple/arguments/synchronize_finished_arguments.dart';

class SynchronizeFinishedScreen extends StatefulWidget {
  static const String routeName = '/synchronize-data/finished';

  @override
  _SynchronizeFinishedScreenState createState() =>
      _SynchronizeFinishedScreenState();
}

class _SynchronizeFinishedScreenState extends State<SynchronizeFinishedScreen> {
  IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final SynchronizeFinishedArguments arguments =
        ModalRoute.of(context).settings.arguments;

    final String profileAssetName = arguments.isMale
        ? 'assets/images/tennis-player-male.svg'
        : 'assets/images/tennis-player-female.svg';

    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          socket.emit('save-user-infos', {
            'username': arguments.username,
            'password': arguments.password,
            'civility': arguments.civility,
            'firstname': arguments.firstname,
            'lastname': arguments.lastname,
            'birthdate': arguments.birthdate,
            'license': arguments.license,
            'ranking': arguments.ranking,
            'partners': arguments.partners,
          });
        },
        label: Text('VALIDER'),
        icon: Icon(Icons.check),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 37.0),
                    child: Container(
                      height: 115,
                      child: SvgPicture.asset(profileAssetName),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Text(
                      '${arguments.firstname} ${arguments.lastname}',
                      style: TextStyle(
                          fontSize: 23, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${arguments.age} ans',
                        style: TextStyle(fontSize: 17, color: Colors.blueGrey),
                      ),
                      Text(
                        arguments.license,
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
                              arguments.ranking,
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
                        ...arguments.partners.map((partner) {
                          return ListTile(
                            leading: Container(
                              height: 45,
                              width: 45,
                              child: SvgPicture.asset(profileAssetName),
                            ),
                            title: Text(partner),
                          );
                        }).toList()
                      ],
                    ),
                  )
                ],
              ),
              /*Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: RaisedButton(
                onPressed: () {

                },
                child: Text('VALIDER',
                style: TextStyle(
                ),),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            )*/
            ],
          ),
        ),
      ),
    );
  }
}
