import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;

  const ConnectivityWidget({Key key, this.child}) : super(key: key);

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  bool _isInternetOn;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          _isInternetOn = true;
        });
        break;
      case ConnectivityResult.none:
      default:
        setState(() {
          _isInternetOn = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.6;

    return Stack(
      children: [
        if (_isInternetOn == null || !_isInternetOn)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: cWidth,
                  height: 250,
                  child: SvgPicture.asset('assets/images/no-connection.svg'),
                ),
                Text(
                  'Aucune connexion',
                  style:
                  TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          widget.child
      ],
    );
  }
}
