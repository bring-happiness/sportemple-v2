import '../../booking/models/booking_slot.dart';
import '../../court/models/court.dart';

class ChooseUserArguments {
  final BookingSlot bookingSlot;
  final Court court;

  ChooseUserArguments(
      {this.bookingSlot,
      this.court});
}
