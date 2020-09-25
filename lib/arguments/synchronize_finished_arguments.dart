import '../models/user.dart';

class SynchronizeFinishedArguments {
  User user;

  SynchronizeFinishedArguments(
      {username,
      password,
      civility,
      firstname,
      lastname,
      birthdate,
      license,
      ranking,
      partners}) {
    user = User(
      username: username,
      password: password,
      civility: civility,
      firstname: firstname,
      lastname: lastname,
      birthdate: birthdate,
      license: license,
      ranking: ranking,
      partners: partners
    );
  }
}
