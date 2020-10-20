import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportemple/booking/widgets/booking_widget.dart';

import '../../base/widgets/refresher_header_widget.dart';
import '../screens/booking_calendar_screen.dart';
import '../skeletons/booking_skeleton.dart';
import '../../user/widgets/user_profile_widget.dart';
import '../models/booking.dart';
import '../repository/booking_repository.dart';
import '../../communique/screens/communiques_screen.dart';
import '../../user/models/user.dart';
import '../../user/repository/user_repository.dart';

class BookingHomeScreen extends StatefulWidget {
  static const String routeName = '/booking/home';

  @override
  _BookingHomeScreenState createState() => _BookingHomeScreenState();
}

class _BookingHomeScreenState extends State<BookingHomeScreen> {
  String _username;
  String _password;
  User _user;
  List<Booking> _bookings;
  bool _isBookingEdited = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      _username = prefs.getString('username');
      _password = prefs.getString('password');

      UserRepository.getByUsername(_username).then((User user) {
        setState(() {
          _user = user;
        });
      });

      BookingRepository.getCurrentBookings(_username, _password)
          .then((List<Booking> bookings) {
        setState(() {
          _bookings = bookings;
        });
      });
    });
  }

  void _onRefresh() {
    setState(() {
      _bookings = null;
    });

    BookingRepository.getCurrentBookings(_username, _password)
        .then((List<Booking> bookings) {
      setState(() {
        _bookings = bookings;
      });

      _refreshController.refreshCompleted();
    });
  }

  void _deleteBooking(BuildContext context, Booking booking) async {
    setState(() {
      _isBookingEdited = true;
    });

    bool success =
        await BookingRepository.cancel(_username, _password, booking.id);

    setState(() {
      _isBookingEdited = false;
    });

    if (success) {
      _bookings.remove(booking);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'La suppression a échoué. Veuillez réessayer',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'RÉESSAYER',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
                _deleteBooking(context, booking);
              },
            )
          ],
        ),
      ));
    }
  }

  void _onDeletePressed(BuildContext context, Booking booking) {
    if (booking.isOwner) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Annulation'),
          content: Text('Voulez vous annuler la réservation ?'),
          actions: [
            FlatButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBooking(context, booking);
              },
            ),
          ],
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Vous ne pouvez pas supprimer cette réservation car vous n\êtes pas le propriétaire',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            )
          ],
        ),
      ));
    }
  }

  void _onAddPressed(BuildContext context) {
    Navigator.of(context).pushNamed(BookingCalendarScreen.routeName);
  }

  Widget _buildCommuniquesButton() {
    final Widget child = Text(
      'Voir les annonces',
      style: TextStyle(fontSize: 17, color: Colors.white),
    );
    final Function onPressed = () {
      Navigator.of(context).pushNamed(CommuniquesScreen.routeName);
    };
    final Color color = Theme.of(context).primaryColor;

    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            child: child,
            color: color,
          )
        : RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: child,
            onPressed: onPressed,
            color: color,
          );
  }

  Widget _buildBody() {
    return ModalProgressHUD(
      inAsyncCall: _isBookingEdited,
      child: Builder(
        builder: (_context) => SmartRefresher(
          enablePullDown: true,
          header: RefresherHeaderWidget(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserProfileWidget(
                    user: _user,
                  ),
                  _buildCommuniquesButton(),
                  Padding(
                    padding: const EdgeInsets.only(top: 37, bottom: 0, left: 7),
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
                  if (_bookings == null)
                    BookingSkeleton(
                      count: 2,
                    ),
                  if (_bookings != null && _bookings.length == 0)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 17),
                          child: Container(
                            height: 170,
                            width: 170,
                            child: SvgPicture.asset(
                                'assets/images/no-booking.svg'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Aucune réservation',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  if (_bookings != null && _bookings.length > 0)
                    ..._bookings.map((Booking booking) {
                      return BookingWidget(
                        booking: booking,
                        onDeletePressed: () =>
                            _onDeletePressed(_context, booking),
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

  @override
  Widget build(BuildContext context) {
    final String title = 'Clichy Tennis';

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: Text(
                title,
              ),
              trailing: GestureDetector(
                child: Icon(
                  CupertinoIcons.add,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => _onAddPressed(context),
              ),
            )
          : AppBar(
              title: Text(title),
            ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _onAddPressed(context),
              child: Icon(Icons.add),
            ),
      body: _buildBody(),
    );
  }
}
