import 'package:flutter/material.dart';
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
