import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/booking_slot_repository.dart';
import '../arguments/choose_partner_arguments.dart';
import '../widgets/partner_widget.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import 'booking_home_screen.dart';

class ChoosePartnerScreen extends StatefulWidget {
  static const String routeName = '/partners/choose';

  @override
  _ChoosePartnerScreenState createState() => _ChoosePartnerScreenState();
}

class _ChoosePartnerScreenState extends State<ChoosePartnerScreen> {
  String username;
  String password;
  User user;
  String _partnerSelected;
  bool isBookingSlot = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Choix du partenaire'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Opacity(
        opacity: hasPartnerSelected ? 1 : 0.3,
        child: FloatingActionButton.extended(
          onPressed: _partnerSelected == null
              ? null
              : () async {
                  final ChoosePartnerArguments arguments =
                      ModalRoute.of(context).settings.arguments;

                  setState(() {
                    isBookingSlot = true;
                  });

                  await BookingSlotRepository.book(
                      username,
                      password,
                      arguments.bookingSlot.date,
                      arguments.bookingSlot.startTime,
                      3600,
                      arguments.court.id,
                      _partnerSelected);

                  setState(() {
                    isBookingSlot = false;
                  });

                  Route route = MaterialPageRoute(
                      builder: (context) => BookingHomeScreen());
                  Navigator.of(context).pushAndRemoveUntil(
                      route, (Route<dynamic> route) => false);
                },
          label: Text('VALIDER'),
          icon: Icon(Icons.check),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isBookingSlot,
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
                    if (user != null)
                      ...user.partners.map((partner) {
                        return Card(
                          child: InkWell(
                            onTap: () => _onPartnerSelected(partner),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PartnerWidget(
                                    partner: partner,
                                    profileAssetName: user.profileAssetName,
                                  ),
                                ),
                                _isPartnerSelected(partner)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Container(),
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
    );
  }
}
