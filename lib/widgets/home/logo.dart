import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/screens/search/search.dart';


class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(left: 15, right:15),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.blur_on,
                color: Theme.of(context).accentColor.withOpacity(0.6),
                size: 24,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Center(
            child: Padding(
              child: Image.asset(kLogoImage, height: 40),
              padding: EdgeInsets.only(bottom: 10.0, top: 30.0),
            ),
          ),
          Positioned(
            top: 30,
            right: 10.0,
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black45),
              iconSize: 24.0,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SearchScreen(isModal: true),
                      fullscreenDialog: true,
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
