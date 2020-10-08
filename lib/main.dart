import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sportemple/screens/booking_calendar_screen.dart';
import 'package:sportemple/screens/choose_partner_screen.dart';

import './screens/communiques_screen.dart';
import './screens/booking_home_screen.dart';
import './screens/login_screen.dart';
import './screens/synchronize_finished_screen.dart';
import './screens/synchronize_screen.dart';

void main() {
  initializeDateFormatting('fr_FR', null).then((value) {
    Intl.defaultLocale = 'fr_FR';
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SynchronizeScreen.routeName: (ctx) => SynchronizeScreen(),
        SynchronizeFinishedScreen.routeName: (ctx) =>
            SynchronizeFinishedScreen(),
        BookingHomeScreen.routeName: (ctx) => BookingHomeScreen(),
        CommuniquesScreen.routeName: (ctx) => CommuniquesScreen(),
        ChoosePartnerScreen.routeName: (ctx) => ChoosePartnerScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == BookingCalendarScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) => BookingCalendarScreen(),
            fullscreenDialog: true
          );
        }

        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
