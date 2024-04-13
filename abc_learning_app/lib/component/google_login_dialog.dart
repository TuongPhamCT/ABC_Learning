import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginDialog extends StatelessWidget {
  const GoogleLoginDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: ColorPalette.googleDialog.withOpacity(0.93),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset(
              AssetHelper.googleLogo,
              width: 95,
              height: 35,
            ),
          ),
          SizedBox(height: 24),
          Text('Choose your account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 20),
          _buildGoogleAccountTile('example@gmail.com', 'John Doe', context),
          _buildGoogleAccountTile('anotherexample@gmail.com', 'Otong', context),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Use another account?',
                  style: TextStyle(
                      color: Color(0xff1C1C1E),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.angleDown,
                  color: Color(0xff263238),
                  size: 16,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleAccountTile(
      String email, String name, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(AssetHelper.ggAvatar, fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  email,
                  style: TextStyle(
                      color: Color(0xff3C3C43).withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  FontAwesomeIcons.angleRight,
                  color: ColorPalette.emailgg.withOpacity(0.6),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
