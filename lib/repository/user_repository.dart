import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserRepository {
  static Future<User> getByUsername(username) async {
    final response =
        await http.get('${DotEnv().env['SPORTEMPLE_API']}/user/$username');

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
