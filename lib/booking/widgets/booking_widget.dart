import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/booking.dart';

class BookingWidget extends StatelessWidget {
  final Booking booking;
  final Function onDeletePressed;

  const BookingWidget({Key key, this.booking, this.onDeletePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 17),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            child: SvgPicture.asset(
                              'assets/images/tennis-store.svg',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              booking != null ? booking.site : '',
                              style: TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          child: SvgPicture.asset(
                              'assets/images/tennis-court.svg'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Container(
                            child: Center(
                              child: Text(
                                booking != null ? booking.court : '',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 7,
                      ),
                      child: Text(
                        'VS',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 23,
                            color: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(235, 235, 235, 1)),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      booking != null ? booking.dateHumanized : '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Container(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset('assets/images/tennis-watch.svg'),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            booking != null ? '${booking.hourHumanized}' : '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Opacity(
                      opacity: booking.isOwner ? 1 : 0.4,
                      child: FlatButton(
                        child: Text(
                          'SUPPRIMER',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                        onPressed: onDeletePressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
