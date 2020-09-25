import 'package:flutter/material.dart';
import 'package:sportemple/repository/communique_repository.dart';
import 'package:sportemple/widgets/communique_widget.dart';

import '../models/communique.dart';

class CommuniquesScreen extends StatefulWidget {
  static const String routeName = '/communiques';

  @override
  _CommuniquesScreenState createState() => _CommuniquesScreenState();
}

class _CommuniquesScreenState extends State<CommuniquesScreen> {
  Communique _communique;

  @override
  void initState() {
    super.initState();

    CommuniqueRepository.getByClubId('57920066').then((Communique communique) {
      setState(() {
        _communique = communique;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Annonces du club'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 17,
                ),
                if (_communique == null || _communique.text.length < 1)
                  Text('Aucune annonce')
                else
                  ..._communique.text
                      .asMap()
                      .map((index, text) => MapEntry(
                          index,
                          Container(
                            width: cWidth,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 37),
                              child: CommuniqueWidget(
                                text: text,
                                index: index + 1,
                              ),
                            ),
                          )))
                      .values
                      .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
