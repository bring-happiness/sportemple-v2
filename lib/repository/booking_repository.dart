import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/booking.dart';

class BookingRepository {
  static Future<List<Booking>> getCurrentBookings(username, password) async {
    final response = await http
        .get('http://localhost:3001/booking/current-reservations', headers: {
      'club_id': '57920066',
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Booking> bookings = List<Booking>();

      data.forEach((booking) => bookings.add(Booking.fromJson(booking)));

      return bookings;
    } else {
      throw Exception('Failed to load booking');
    }
  }

  static Future<bool> cancelBooking(username, password, bookingId) async {
    final response = await http.post('http://localhost:3001/booking/cancel',
        body: {
          'booking_id': bookingId
        },
        headers: {
          'club_id': '57920066',
          'username': username,
          'password': password
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to cancel booking');
    }
  }
}
