import 'package:flutter/material.dart';
import '../../court/models/court.dart';

class BookingSlotWidget extends StatelessWidget {
  final Court court;
  final Function onCourtTapped;

  const BookingSlotWidget({Key key, this.court, this.onCourtTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: InkWell(
          splashColor: Theme.of(context).primaryColor,
          onTap: onCourtTapped,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
            child: Column(
              children: [
                Text(
                  court.courtNumber.toString(),
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  court.site.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                Text(
                  court.condition.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ));
  }
}
