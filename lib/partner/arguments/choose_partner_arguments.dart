import '../../booking/models/booking_slot.dart';
import '../../court/models/court.dart';

class ChoosePartnerArguments {
  final BookingSlot bookingSlot;
  final Court court;

  ChoosePartnerArguments(
      {this.bookingSlot,
      this.court});
}
