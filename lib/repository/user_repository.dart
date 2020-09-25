import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserRepository {
  static Future<User> getByUsername (username) async {
    final response = await http.get('http://localhost:3001/user/$username');

    if(response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}