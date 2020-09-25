import 'package:age/age.dart';

class User {
  final String _id;
  final String username;
  final String password;
  final String civility;
  final String firstname;
  final String lastname;
  final String birthdate;
  final String license;
  final String ranking;
  final List<dynamic> partners;

  User(
      {String id,
        this.username,
        this.password,
        this.civility,
        this.firstname,
        this.lastname,
        this.birthdate,
        this.license,
        this.ranking,
        this.partners}): _id = id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      civility: json['civility'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      birthdate: json['birthdate'],
      license: json['license'],
      ranking: json['ranking'],
      partners: json['partners'],
    );
  }

  bool get isMale {
    return this.civility == 'M';
  }

  DateTime get birthdateTime {
    List<String> dateSplitted = this.birthdate.split('/');

    return DateTime(int.parse(dateSplitted[2]), int.parse(dateSplitted[1]),
        int.parse(dateSplitted[0]));
  }

  int get age {
    AgeDuration age = Age.dateDifference(
        fromDate: this.birthdateTime, toDate: DateTime.now());

    return age.years;
  }
}
