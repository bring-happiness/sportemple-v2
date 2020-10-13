import '../../user/models/user.dart';

class SynchronizeUserFinishedArguments {
  User user;

  SynchronizeUserFinishedArguments(
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
