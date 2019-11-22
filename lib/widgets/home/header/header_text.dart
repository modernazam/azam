import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:tashkentsupermarket/screens/search/search.dart';

class HeaderText extends StatelessWidget {

  HeaderText();

  @override
  Widget build(BuildContext context) {
    double fontSize = 22.0;

    return Container(
      padding: EdgeInsets.only(
          top: 30.0,
          left: 30.0,
          right: 30.0,
          bottom: 20.0),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        bottom: false,
        top: true,
        child: Stack(
          children: <Widget>[
            AutoSizeText(
              'Tashkent Supermarket',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 30,
              ),
              maxLines: 3,
              minFontSize: fontSize - 10,
              maxFontSize: fontSize,
              group: AutoSizeGroup(),
            ),
            Positioned(
              right: -10.0,
              bottom: -12.0,
              child: IconButton(
                icon: Icon(Icons.search),
                iconSize: 26.0,
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
      ),
    );
  }
}
