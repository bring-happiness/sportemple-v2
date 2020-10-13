import 'package:intl/intl.dart';

import '../../_extensions/string_extension.dart';

class Booking {
  final String id;
  final String date;
  final String hour;
  final String site;
  final String court;
  final String gameType;
  final String ownerType;

  Booking(
      {this.id,
      this.date,
      this.hour,
      this.site,
      this.court,
      this.gameType,
      this.ownerType});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      date: json['date'],
      hour: json['heure'],
      site: json['site'],
      court: json['court'],
      gameType: json['jeu'],
      ownerType: json['type'],
    );
  }

  DateTime get dateTime {
    List<String> dateSplitted = this.date.split('/');
    int day = int.parse(dateSplitted[0].substring(dateSplitted[0].length - 2));
    int month = int.parse(dateSplitted[1]);
    int year = int.parse(dateSplitted[2]);

    return DateTime(year, month, day);
  }

  String get dateHumanized {
    DateTime todayWithHours = DateTime.now();
    DateTime today =
        DateTime(todayWithHours.year, todayWithHours.month, todayWithHours.day);
    int differenceInDays = this.dateTime.difference(today).inDays;

    DateFormat formatterWeekDay = DateFormat('EEEE');
    String weekDay = formatterWeekDay.format(this.dateTime).capitalize();

    DateFormat formatterFullDate = DateFormat('EEEE d MMMM');
    String fullDate = formatterFullDate.format(this.dateTime).capitalize();


    if (differenceInDays == 0) {
      return 'Aujourd\'hui ($weekDay)';
    } else if (differenceInDays == 1) {
      return 'Demain ($weekDay)';
    }

    return fullDate;
  }

  String get hourHumanized {
    String HOUR_SEPARATOR = 'h';
    String hour = this.hour.replaceFirst(':', HOUR_SEPARATOR);
    int hourIncremented = int.parse(hour.split(HOUR_SEPARATOR)[0]) + 1;
    String nextHour = hourIncremented.toString() + HOUR_SEPARATOR + hour.split(HOUR_SEPARATOR)[1];

    return '$hour - $nextHour';
  }

  bool get isOwner {
    return this.ownerType.toLowerCase() == 'propriétaire';
  }
}
