import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../extensions/string_extension.dart';

class BookingCalendarScreen extends StatefulWidget {
  static const String routeName = '/booking/calendar';

  @override
  _BookingCalendarScreenState createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  IO.Socket socket;
  DateTime _currentDay;
  final _pageController = PageController(
    viewportFraction: 0.95,
  );
  bool _isPageViewChangeProgrammatically = false;

  @override
  void initState() {
    super.initState();

    DateTime todayWithHours = DateTime.now();
    _currentDay =
        DateTime(todayWithHours.year, todayWithHours.month, todayWithHours.day);

    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
    });

    /*socket.on('login-sync-infos-finished', (data) {
      print('login sync infos finished');
    });*/
  }

  DateTime get today {
    DateTime todayWithHours = DateTime.now();
    DateTime today =
        DateTime(todayWithHours.year, todayWithHours.month, todayWithHours.day);

    return today;
  }

  int get differenceInDays {
    print(_currentDay);
    print(today);
    return _currentDay.difference(today).inDays;
  }

  bool get canDecrement {
    return differenceInDays > 0;
  }

  String get currentDayHumanized {
    DateFormat formatterWeekDay = DateFormat('EEEE');
    String weekDay = formatterWeekDay.format(_currentDay).capitalize();

    DateFormat formatterFullDate = DateFormat('EEEE d MMMM');
    String fullDate = formatterFullDate.format(_currentDay).capitalize();

    if (differenceInDays == 0) {
      return 'Aujourd\'hui';
    } else if (differenceInDays == 1) {
      return 'Demain ($weekDay)';
    } else if (differenceInDays == 2) {
      return 'Après-demain ($weekDay)';
    }

    return fullDate;
  }

  void _decrementCurrentDay({bool changePageView = false}) {
    if (!canDecrement) {
      return;
    }

    setState(() {
      _currentDay = _currentDay.add(Duration(days: -1));

      if (changePageView) {
        _isPageViewChangeProgrammatically = true;
        _pageController.previousPage(
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });
  }

  void _incrementCurrentDay({bool changePageView = false}) {
    setState(() {
      _currentDay = _currentDay.add(Duration(days: 1));

      if (changePageView) {
        _isPageViewChangeProgrammatically = true;
        _pageController.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });
  }

  void _onDatePressed(context) async {
    final oldCurrentDay = _currentDay;
    final DateTime datePicked = await showDatePicker(
      context: context,
      initialDate: _currentDay,
      firstDate: today,
      lastDate: today.add(
        Duration(days: 13), // todo: must be a club config data
      ),
    );

    if (datePicked == null)  {
      return;
    }

    setState(() {
      _currentDay = datePicked;

      final differenceInDays = _currentDay.difference(oldCurrentDay).inDays;
      final currentPage = _pageController.page.round();
      print(currentPage + differenceInDays);
      _isPageViewChangeProgrammatically = true;
      _pageController.jumpToPage(currentPage + differenceInDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('C.S Clichy Tennis'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              if (_isPageViewChangeProgrammatically) {
                _isPageViewChangeProgrammatically = false;
                return;
              }

              if (page > _pageController.page) {
                _incrementCurrentDay();
              } else {
                _decrementCurrentDay();
              }
            },
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  child: ListView.builder(
                    itemBuilder: (context, itemCount) => Text('Coucou'),
                    itemCount: 200,
                  ),
                  height: 2000,
                  //color: position % 2 == 0 ? Colors.pink : Colors.cyan,
                ),
              );
            },
          ),
          Positioned(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 31,
                      ),
                      onPressed: canDecrement
                          ? () => _decrementCurrentDay(
                                changePageView: true,
                              )
                          : null,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 270,
                      child: FlatButton(
                        child: Text(
                          currentDayHumanized,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                          ),
                        ),
                        onPressed: () => _onDatePressed(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 31),
                      onPressed: () => _incrementCurrentDay(
                        changePageView: true,
                      ),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
