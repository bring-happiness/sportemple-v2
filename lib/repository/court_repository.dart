import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/court.dart';

class CourtRepository {
  static Future<List<Court>> getAll() async {
    final response = await http
        .get('${DotEnv().env['SPORTEMPLE_API']}/courts/all', headers: {
      'club_id': '57920066'
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Court> courts = List<Court>();

      data.forEach((court) => courts.add(Court.fromJson(court)));

      return courts;
    } else {
      throw Exception('Failed to load courts');
    }
  }
}
