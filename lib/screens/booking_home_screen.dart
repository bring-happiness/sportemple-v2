import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  void _onRefresh() {
    setState(() {
      bookings = null;
    });

    BookingRepository.getCurrentBookings(username, password)
        .then((List<Booking> _bookings) {
      setState(() {
        bookings = _bookings;
      });

      _refreshController.refreshCompleted();
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
      body: Builder(
        builder: (_context) => SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SafeArea(
            child: SingleChildScrollView(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 11.0),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user != null ? user.firstname : '',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Theme.of(context).primaryColor),
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
                  RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      'Voir les annonces',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(CommuniquesScreen.routeName);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 17, bottom: 0, left: 7),
                    child: Row(
                      children: [
                        Text(
                          'Mes réservations',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(70, 70, 70, 1)),
                        ),
                      ],
                    ),
                  ),
                  if (bookings == null)
                    Container(
                      height: 440,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 27),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.white70),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SkeletonAnimation(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SkeletonAnimation(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SkeletonAnimation(
                                            child: Container(
                                              width: 40,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SkeletonAnimation(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[300]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SkeletonAnimation(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SkeletonAnimation(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      /*Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, bottom: 5.0),
                                                child: SkeletonAnimation(
                                                  child: Container(
                                                    height: 15,
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.6,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                        color: Colors.grey[300]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 15.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 5.0),
                                                  child: SkeletonAnimation(
                                                    child: Container(
                                                      width: 60,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0),
                                                          color: Colors.grey[300]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),*/
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  if (bookings != null)
                    ...bookings.map((Booking booking) {
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 17),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 70,
                                            child: SvgPicture.asset(
                                                'assets/images/tennis-store.svg'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              booking != null
                                                  ? booking.site
                                                  : '',
                                              style: TextStyle(fontSize: 17),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          child: SvgPicture.asset(
                                              'assets/images/tennis-court.svg'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                                booking != null
                                                    ? booking.court
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 7,
                                      ),
                                      child: Text(
                                        'VS',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 23,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(235, 235, 235, 1)),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      booking != null
                                          ? booking.dateHumanized
                                          : '',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: SvgPicture.asset(
                                          'assets/images/tennis-watch.svg'),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            booking != null
                                                ? '${booking.hourHumanized}'
                                                : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Opacity(
                                      opacity: booking.isOwner ? 1 : 0.6,
                                      child: FlatButton(
                                        child: Text(
                                          'SUPPRIMER',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).errorColor),
                                        ),
                                        onPressed: () {
                                          if (booking.isOwner) {
                                            showDialog(
                                              context: _context,
                                              builder: (_) => AlertDialog(
                                                title: Text('Annulation'),
                                                content: Text(
                                                    'Voulez vous annuler la réservation ?'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('Non'),
                                                    onPressed: () {
                                                      Navigator.of(_context)
                                                          .pop();
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('Oui'),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            Scaffold.of(_context)
                                                .showSnackBar(SnackBar(
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Vous ne pouvez pas annuler car vous n\êtes pas le propriétaire',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Scaffold.of(_context)
                                                          .hideCurrentSnackBar();
                                                    },
                                                  )
                                                ],
                                              ),
                                            ));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
