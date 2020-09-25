import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/communique.dart';

class CommuniqueRepository {
  static Future<Communique> getByClubId (clubId) async {
    final response = await http.get('http://localhost:3001/communique/$clubId');

    if(response.statusCode == 200) {
      return Communique.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load communique');
    }
  }
}