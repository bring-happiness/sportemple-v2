import 'package:flutter/material.dart';

class CommuniqueWidget extends StatelessWidget {
  final int index;
  final String text;

  const CommuniqueWidget({Key key, this.index, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
            child: Text(index.toString(), style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),),
          ),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 17),
        )
      ],
    );
  }
}
