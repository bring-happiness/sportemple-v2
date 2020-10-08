class Court {
  final String id;
  final String site;
  final int courtNumber;
  final bool indoor;
  final bool bubble;
  final bool lights;

  Court(
      {this.id,
      this.site,
      this.courtNumber,
      this.indoor,
      this.bubble,
      this.lights});

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
        id: json['id'],
        site: json['site'],
        courtNumber: json['court'],
        indoor: json['indoor'],
        bubble: json['bubble'],
        lights: json['lights']);
  }

  String get condition {
    if (indoor) return 'Intérieur';
    else if (bubble) return 'Bulle';
    else return 'Extérieur';
  }
}
