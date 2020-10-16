import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../repository/communique_repository.dart';
import '../widgets/communique_widget.dart';
import '../models/communique.dart';
import '../skeletons/communique_skeleton.dart';

class CommuniquesScreen extends StatefulWidget {
  static const String routeName = '/communiques';

  @override
  _CommuniquesScreenState createState() => _CommuniquesScreenState();
}

class _CommuniquesScreenState extends State<CommuniquesScreen> {
  Communique _communique;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    CommuniqueRepository.getByClubId('57920066').then((Communique communique) {
      setState(() {
        _communique = communique;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Annonces du club'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    CommuniqueSkeleton(
                      width: cWidth,
                    )
                  else if (_communique == null ||
                      _communique.text == null ||
                      _communique.text.length < 1)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          child: Container(
                            height: 240,
                            width: 240,
                            child:
                                SvgPicture.asset('assets/images/no-data.svg'),
                          ),
                        ),
                        Text(
                          'Aucune annonce',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[600]),
                        ),
                      ],
                    )
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
      ),
    );
  }
}
