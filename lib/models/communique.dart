class Communique {
  final String _id;
  final String clubId;
  final String title;
  final List<dynamic> text;

  Communique(
      {String id,
        this.clubId,
        this.title,
        this.text}): _id = id;

  factory Communique.fromJson(Map<String, dynamic> json) {
    return Communique(
      id: json['_id'],
      clubId: json['clubId'],
      title: json['title'],
      text: json['text'],
    );
  }
}
