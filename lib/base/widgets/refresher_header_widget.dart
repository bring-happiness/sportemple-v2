import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefresherHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? WaterDropHeader(
            complete: Text('Rafraichissement réussie'),
            waterDropColor: Theme.of(context).primaryColor,
          )
        : WaterDropMaterialHeader();
  }
}
