import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'common/config.dart';
import 'common/tools.dart';
import 'common/styles.dart';

import 'models/app.dart';
import 'models/cart.dart';
import 'models/category.dart';
import 'models/order.dart';
import 'models/payment_method.dart';
import 'models/product.dart';
import 'models/recent_product.dart';
import 'models/search.dart';
import 'models/shipping_method.dart';
import 'models/user.dart';
import 'models/wishlist.dart';
import 'screens/cart.dart';
import 'screens/checkout/index.dart';
import 'screens/login.dart';
import 'screens/notification.dart';
import 'screens/orders.dart';
import 'screens/products.dart';
import 'screens/registration.dart';
import 'screens/onboard_screen.dart';
import 'services/index.dart';
import 'tabbar.dart';


FirebaseAnalytics analytics = FirebaseAnalytics();

class SplashScreenAnimate extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreenAnimate> {
  
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen)
      return false;
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      return SplashScreen.callback(
          name: "assets/splashscreen.flr",
          startAnimation: 'logoanim',
          backgroundColor: Colors.white,
          onError: (error, stack) => {},
          onSuccess: (_) async {
            bool isFirstSeen = await checkFirstSeen();
            //print('isFirstSeen' + isFirstSeen.toString());
            if (isFirstSeen) return Navigator.pushReplacementNamed(context, '/onboardscreen');

            return Navigator.pushReplacementNamed(context, '/home');
          },
          loopAnimation: '1',
          until: () => Future.delayed(Duration(seconds: 1)),
          endAnimation: '1'
      );
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> with AfterLayoutMixin {
    final _app = AppModel();
    final _order = OrderModel();
    final _search = SearchModel();
    final _recent = RecentModel();
    final _product = ProductModel();
    final _wishlist = WishListModel();
    final _paymentMethod = PaymentMethodModel();
    final _shippingMethod = ShippingMethodModel();
  
    @override
    void afterFirstLayout(BuildContext context) {
        Services().setAppConfig(serverConfig);
        _app.loadAppConfig();
    }

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider<AppModel>.value(
          value: _app,
          child: Consumer<AppModel>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Container(color: Theme.of(context).backgroundColor,);
              }

              return MultiProvider(
                providers: [
                  Provider<ProductModel>.value(value: _product),
                  Provider<WishListModel>.value(value: _wishlist),
                  Provider<ShippingMethodModel>.value(value: _shippingMethod),
                  Provider<PaymentMethodModel>.value(value: _paymentMethod),
                  Provider<OrderModel>.value(value: _order),
                  Provider<SearchModel>.value(value: _search),
                  Provider<RecentModel>.value(value: _recent,),
                  ChangeNotifierProvider(builder: (context) => UserModel()),
                  ChangeNotifierProvider(builder: (context) => CategoryModel()),
                  ChangeNotifierProvider(builder: (context) => CartModel())
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [
                    FirebaseAnalyticsObserver(analytics: analytics),
                  ],
                  home: SplashScreenAnimate(),
                  routes: <String, WidgetBuilder>{
                    "/home": (context) => MainTabs(),
                    '/orders': (context) => MyOrders(),
                    "/login": (context) => LoginScreen(),
                    '/wishlist': (context) => WishList(),
                    '/checkout': (context) => Checkout(),
                    '/notify': (context) => Notifications(),
                    '/products': (context) => ProductsPage(),
                    '/onboardscreen': (context) => OnBoardScreen(),
                    "/register": (context) => RegistrationScreen(),
                  },
                  theme: Provider.of<AppModel>(context).darkTheme
                      ? buildDarkTheme()
                          .copyWith(primaryColor: HexColor(_app.appConfig["Setting"]["MainColor"]))
                      : buildLightTheme()
                          .copyWith(primaryColor: HexColor(_app.appConfig["Setting"]["MainColor"])),
                ),
              );
            },
          ),
        );
    }
}
