import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PartnerWidget extends StatelessWidget {
  final String partner;
  final String profileAssetName;

  const PartnerWidget({Key key, this.partner, this.profileAssetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        child: profileAssetName != null ? SvgPicture.asset(profileAssetName) : Container(),
      ),
      title: Text(partner),
    );
  }
}
