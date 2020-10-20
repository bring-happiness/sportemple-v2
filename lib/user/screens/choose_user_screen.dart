import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportemple/connectivity/widgets/connectivity_widget.dart';

import '../../booking/repository/booking_slot_repository.dart';
import '../arguments/choose_user_arguments.dart';
import '../widgets/user_list_item_widget.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import '../../booking/screens/booking_home_screen.dart';

class ChooseUserScreen extends StatefulWidget {
  static const String routeName = '/partners/choose';

  @override
  _ChooseUserScreenState createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  String _username;
  String _password;
  User _user;
  String _partnerSelected;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      _username = prefs.getString('username');
      _password = prefs.getString('password');

      UserRepository.getByUsername(_username).then((User _user) {
        setState(() {
          this._user = _user;
        });
      });
    });
  }

  void _onPartnerSelected(String partner) {
    setState(() {
      _partnerSelected = partner;
    });
  }

  bool _isPartnerSelected(String partner) {
    return _partnerSelected == partner;
  }

  bool get hasPartnerSelected {
    return _partnerSelected != null;
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'Choix du partenaire';

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        middle: Text(
          title,
        ),
      ) : AppBar(
        title: Text(title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 7,
        ),
        child: Opacity(
          opacity: hasPartnerSelected ? 1 : 0.3,
          child: FloatingActionButton.extended(
            onPressed: !hasPartnerSelected
                ? null
                : () async {
                    final ChooseUserArguments arguments =
                        ModalRoute.of(context).settings.arguments;

                    setState(() {
                      _isBooking = true;
                    });

                    await BookingSlotRepository.book(
                        _username,
                        _password,
                        arguments.bookingSlot.date,
                        arguments.bookingSlot.startTime,
                        3600,
                        arguments.court.id,
                        _partnerSelected);

                    setState(() {
                      _isBooking = false;
                    });

                    Route route = MaterialPageRoute(
                        builder: (context) => BookingHomeScreen());
                    Navigator.of(context).pushAndRemoveUntil(
                        route, (Route<dynamic> route) => false);
                  },
            label: const Text('VALIDER'),
            icon: const Icon(Icons.check),
          ),
        ),
      ),
      body: ConnectivityWidget(
        child: ModalProgressHUD(
          inAsyncCall: _isBooking,
          child: Builder(
            builder: (_context) => SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 17,
                    bottom: 50,
                  ),
                  child: Column(
                    children: [
                      if (_user != null)
                        ..._user.partners.map((partner) {
                          return Card(
                            child: InkWell(
                              onTap: () => _onPartnerSelected(partner),
                              splashColor: Theme.of(context).primaryColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: UserListItemWidget(
                                      partner: partner,
                                      profileAssetName: _user.profileAssetName,
                                    ),
                                  ),
                                  if (_isPartnerSelected(partner))
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }).toList()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
