class Booking {
  final String id;
  final String date;
  final String hour;
  final String site;
  final String court;
  final String gameType;
  final String ownerType;

  Booking({this.id,
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
}
