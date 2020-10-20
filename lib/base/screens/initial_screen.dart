import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../booking/screens/booking_home_screen.dart';
import '../../login/screens/login_screen.dart';

class InitialScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  /*int currentTabIndex = 0;
  List<Widget> tabs = [
    BookingHomeScreen(),
    ChooseUserScreen(),
  ];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }*/

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String username = prefs.getString('username');
      String password = prefs.getString('password');

      if (username == null || password == null) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(BookingHomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();

    /*if (Platform.isIOS) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'Réservations'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search), label: 'Partenaires'),
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return BookingHomeScreen();
                break;
              case 1:
                return ChooseUserScreen();
                break;
              default:
                return BookingHomeScreen();
                break;
            }
          });
    }
    //Android Scafold
    else {
      return Scaffold(
        // Body Where the content will be shown of each page index
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white60,
            selectedItemColor: Colors.white,
            currentIndex: currentTabIndex,
            onTap: onTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Réservations'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Partenaires'),
            ]),
      );*/

      /*DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.home),
                ),
              ],
            ),
          ),
          // Body Where the content will be shown of each page index
          body: TabBarView(
            children: tabs,
          ),
      );
    }*/
  }
}
