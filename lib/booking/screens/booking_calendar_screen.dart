import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sportemple/connectivity/widgets/connectivity_widget.dart';

import '../../_extensions/string_extension.dart';
import '../../court/models/court.dart';
import '../models/booking_slot.dart';
import '../repository/booking_slot_repository.dart';
import '../../user/arguments/choose_user_arguments.dart';
import '../../court/repository/court_repository.dart';
import '../../user/screens/choose_user_screen.dart';
import '../widgets/booking_slot_widget.dart';

class BookingCalendarScreen extends StatefulWidget {
  static const String routeName = '/booking/calendar';

  @override
  _BookingCalendarScreenState createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  IO.Socket _socket;
  DateTime _currentDay;
  List<BookingSlot> bookingSlots = List<BookingSlot>();
  final _pageController = PageController();
  bool _isPageViewChangeProgrammatically = false;
  List<Court> _courtsInfos = List<Court>();

  @override
  void initState() {
    super.initState();

    DateTime todayWithHours = DateTime.now();
    _currentDay =
        DateTime(todayWithHours.year, todayWithHours.month, todayWithHours.day);

    BookingSlotRepository.getAllCollapse()
        .then((List<BookingSlot> _bookingSlots) {
      setState(() {
        bookingSlots = _bookingSlots;
      });
    });

    CourtRepository.getAll().then((List<Court> courts) {
      setState(() {
        _courtsInfos = courts;
      });
    });

    _socket = IO.io(DotEnv().env['SPORTEMPLE_API'], <String, dynamic>{
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
            duration: Duration(milliseconds: 400), curve: Curves.ease);
      }
    });
  }

  void _incrementCurrentDay({bool changePageView = false}) {
    setState(() {
      _currentDay = _currentDay.add(Duration(days: 1));

      if (changePageView) {
        _isPageViewChangeProgrammatically = true;
        _pageController.nextPage(
            duration: Duration(milliseconds: 400), curve: Curves.ease);
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

    if (datePicked == null) {
      return;
    }

    setState(() {
      _currentDay = datePicked;

      final differenceInDays = _currentDay.difference(oldCurrentDay).inDays;
      final currentPage = _pageController.page.round();

      _isPageViewChangeProgrammatically = true;
      _pageController.jumpToPage(currentPage + differenceInDays);
    });
  }

  void _onCourtTapped(
      BuildContext context, BookingSlot bookingSlot, Court court) {
    Navigator.of(context).pushNamed(
      ChooseUserScreen.routeName,
      arguments: ChooseUserArguments(
        bookingSlot: bookingSlot,
        court: court,
      ),
    );
  }

  Court _getCourt(String courtId) {
    return _courtsInfos.firstWhere((Court _court) => _court.id == courtId);
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'Choix du terrain';

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        middle: Text(
          title,
        ),
      ) : AppBar(
        title: Text(title),
      ),
      body: ConnectivityWidget(
        child: SafeArea(
          bottom: false,
          child: Stack(
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
                  final _bookingSlots = bookingSlots
                      .where((BookingSlot _bookingSlot) =>
                          _bookingSlot.dateTime ==
                          today.add(Duration(days: position)))
                      .toList();

                  return Container(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 17,
                      right: 17,
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, itemCount) {
                        final BookingSlot bookingSlot =
                            _bookingSlots[itemCount];

                        return Container(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 21,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bookingSlot.startTimeHumanized,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bookingSlot.numberOfCourtsHumanized
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Container(
                                width: double.infinity,
                                child: Wrap(
                                  children: [
                                    ...bookingSlot.courts.map((_courtId) {
                                      final Court _court = _getCourt(_courtId);

                                      return BookingSlotWidget(
                                        court: _court,
                                        onCourtTapped: () => _onCourtTapped(context, bookingSlot, _court),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: _bookingSlots.length,
                    ),
                    //color: position % 2 == 0 ? Colors.pink : Colors.cyan,
                  );
                },
              ),
              Positioned(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Expanded(
                          child: FlatButton(
                            splashColor: Theme.of(context).primaryColor,
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
        ),
      ),
    );
  }
}
