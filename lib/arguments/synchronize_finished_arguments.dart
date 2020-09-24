import 'package:age/age.dart';

class SynchronizeFinishedArguments {
  final String username;
  final String password;
  final String civility;
  final String firstname;
  final String lastname;
  final String birthdate;
  final String license;
  final String ranking;
  final List<dynamic> partners;

  SynchronizeFinishedArguments(
      {this.username,
      this.password,
      this.civility,
      this.firstname,
      this.lastname,
      this.birthdate,
      this.license,
      this.ranking,
      this.partners});

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
