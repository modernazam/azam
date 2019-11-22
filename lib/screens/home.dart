
import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/models/app.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/notification.dart';
import 'package:tashkentsupermarket/screens/deeplink_item.dart';
import 'package:tashkentsupermarket/widgets/home/index.dart';
import 'package:uni_links/uni_links.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, AfterLayoutMixin<HomeScreen> {
      
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Uri _latestUri;
  StreamSubscription _sub;
  int itemId;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
    firebaseCloudMessagingListeners();
  }
  
  initPlatformState() async {
    await initPlatformStateForStringUniLinks();
  }

  
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
          setState(() {
            itemId = int.parse(_latestUri.path.split('/')[1]);
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDeepLink(
                      itemId: itemId,
                    )),
          );
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });
  }

  _saveMessage(message) {
    FStoreNotification a = FStoreNotification.fromJsonFirebase(message);
    a.saveToLocal(message['notification'] != null
        ? message['notification']['tag']
        : message['data']['google.message_id']);
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) => _saveMessage(message),
      onResume: (Map<String, dynamic> message) => _saveMessage(message),
      onLaunch: (Map<String, dynamic> message) => _saveMessage(message),
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<CategoryModel>(context).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<AppModel>(
      builder: (context, value, child) {
        if (value.appConfig == null) {
          return kLoadingWidget(context);
        }
        return HomeLayout();
      },
    );
  }
}
