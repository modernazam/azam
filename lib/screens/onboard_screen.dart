import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  
  final pages = [
      PageViewModel(
          pageColor: const Color(0xFF03A9F4),
          // iconImageAssetPath: 'assets/air-hostess.png',
          //bubble: Image.asset('assets/air-hostess.png'),
          body: Text(
            'Tashkent Super Market is on the way to serve you.',
          ),
          title: Text(
            "Welcome to \n Tashkent Super Market",
            textAlign: TextAlign.center
          ),
          titleTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 40.0, color: Colors.white),
          bodyTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 24.0, color: Colors.white),
          mainImage: Image.asset(
            'assets/images/intro/1.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          )
      ),
      PageViewModel(
        pageColor: const Color(0xFF8BC34A),
        //iconImageAssetPath: 'assets/waiter.png',
        body: Text(
          'See all things happening around you just by a click in your phone. Fast, convenient and clean.',
        ),
        title: Text('Connect Surrounding World'),
        mainImage: Image.asset(
          'assets/images/intro/2.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 38.0, color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 24.0, color: Colors.white),
      ),
      PageViewModel(
        pageColor: const Color(0xFF607D8B),
        //iconImageAssetPath: 'assets/taxi-driver.png',
        body: Text(
          "Waiting no more, let's see what we get!",
        ),
        title: Text("Let's Get Started"),
        mainImage: Image.asset(
          'assets/images/intro/3.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 48.0, color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', fontSize: 28.0, color: Colors.white),
      ),
    ];

  @override
  void initState() {
    super.initState();
  }

  Future setFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }
  
  @override
  Widget build(BuildContext context) {
      return IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: false,
          onTapDoneButton: () {
              setFirstSeen();
              Navigator.pushReplacementNamed(context, '/home');
          },
          pageButtonTextStyles: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
          )
      );
  }

}
