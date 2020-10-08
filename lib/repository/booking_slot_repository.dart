import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/booking_slot.dart';

class BookingSlotRepository {
  static Future<List<BookingSlot>> getAllCollapse() async {
    final response = await http.get(
        'http://localhost:3001/booking-slot/all/collapse',
        headers: {'club_id': '57920066'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<BookingSlot> bookingSlots = List<BookingSlot>();

      data.forEach(
          (bookingSlot) => bookingSlots.add(BookingSlot.fromJson(bookingSlot)));

      return bookingSlots;
    } else {
      throw Exception('Failed to load booking slots');
    }
  }

  static Future<dynamic> book(String username, String password, String date,
      String time, int duration, String court, String partner) async {
    final response =
        await http.post('http://localhost:3001/booking/book', body: {
      'date': date,
      'time': time,
      'duration': duration.toString(),
      'court': court,
      'partner': partner,
    }, headers: {
      'club_id': '57920066',
      'username': username,
      'password': password
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to book booking slot');
    }
  }
}
