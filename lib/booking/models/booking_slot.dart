class BookingSlot {
  final String label;
  final List<dynamic> courts;
  final String date;
  final String startTime;
  final bool isFree;
  final int width;

  BookingSlot(
      {this.label,
      this.courts,
      this.date,
      this.startTime,
      this.isFree,
      this.width});

  factory BookingSlot.fromJson(Map<String, dynamic> json) {
    return BookingSlot(
        label: json['label'],
        courts: json['courts'],
        date: json['date'],
        startTime: json['startTime'],
        isFree: json['isFree'],
        width: json['width']);
  }

  DateTime get dateTime {
    List<String> dateSplitted = this.date.split('-');

    return DateTime(int.parse(dateSplitted[0]), int.parse(dateSplitted[1]),
        int.parse(dateSplitted[2]));
  }

  String get startTimeHumanized {
    return this.startTime.replaceFirst(':', 'h');
  }

  int get numberOfCourts {
    return this.courts.length;
  }

  String get numberOfCourtsHumanized {
    String suffix = 'court disponible';

    if (this.numberOfCourts > 1) suffix = 'courts disponibles';

    return '${this.numberOfCourts.toString()} $suffix';
  }
}
