import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportemple/screens/communiques_screen.dart';
import 'package:sportemple/screens/booking_home_screen.dart';
import 'package:sportemple/screens/login_screen.dart';
import 'package:sportemple/screens/synchronize_finished_screen.dart';
import 'package:sportemple/screens/synchronize_screen.dart';

void main() {
  runApp(MyApp());
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
        SynchronizeFinishedScreen.routeName: (ctx) => SynchronizeFinishedScreen(),
        BookingHomeScreen.routeName: (ctx) => BookingHomeScreen(),
        CommuniquesScreen.routeName: (ctx) => CommuniquesScreen()
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
