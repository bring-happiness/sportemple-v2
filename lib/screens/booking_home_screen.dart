import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/booking.dart';
import '../repository/booking_repository.dart';
import './communiques_screen.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class BookingHomeScreen extends StatefulWidget {
  static const String routeName = '/booking/home';

  @override
  _BookingHomeScreenState createState() => _BookingHomeScreenState();
}

class _BookingHomeScreenState extends State<BookingHomeScreen> {
  IO.Socket socket;
  String username;
  String password;
  User user;
  List<Booking> bookings;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      username = prefs.getString('username');
      password = prefs.getString('password');

      UserRepository.getByUsername(username).then((User _user) {
        setState(() {
          user = _user;
        });
      });

      BookingRepository.getCurrentBookings(username, password)
          .then((List<Booking> _bookings) {
        setState(() {
          bookings = _bookings;
        });
      });
    });

    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final String profileAssetName = (user != null && user.isMale)
        ? 'assets/images/tennis-player-male.svg'
        : 'assets/images/tennis-player-female.svg';

    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null ? user.firstname : '',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                user != null ? user.lastname : '',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.blueGrey),
                              )
                            ],
                          ),
                          trailing: Container(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: Text(
                                user != null ? user.ranking : '',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 23),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: SvgPicture.asset(profileAssetName),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 27,
                bottom: 4,
                left: 20
              ),
              child: Row(
                children: [
                  Text(
                    'Mes réservations',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            if(bookings != null)
            ...bookings.map((Booking booking) {
              return Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(booking != null ? booking.date : ''),
                        Text(booking != null ? booking.hour : '')
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
            RaisedButton(
              child: Text(
                'Voir les annonces',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CommuniquesScreen.routeName);
              },
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
