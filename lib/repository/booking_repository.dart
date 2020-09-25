import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/booking.dart';

class BookingRepository {
  static Future<List<Booking>> getCurrentBookings(username, password) async {
    final response = await http.get(
        'http://localhost:3001/booking/current-reservations/57920066/$username/$password');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Booking> bookings = List<Booking>();

      data.forEach((booking) => bookings.add(Booking.fromJson(booking)));

      return bookings;
    } else {
      throw Exception('Failed to load booking');
    }
  }
}
