import 'dart:io' show Platform;

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/user.dart';
import 'package:tashkentsupermarket/models/wishlist.dart';

import 'notification.dart';

class SettingScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  SettingScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final bannerHigh = 200.0;
  bool enabledNotification = true;
  String appID = "";
  String output = "";
  
  /*
  RateMyApp _rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
  );*/

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
        //print(onValue);
      });
    }else {
      AppReview.getAppID.then((String onValue) {
        setState(() {
          appID = onValue;
        });
        //print("App ID" + appID);
      });
    }
    Future.delayed(Duration.zero, ()async{
      checkNotificationPermission();
    });
  }

  void checkNotificationPermission() async {
    try {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        if (mounted)
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
      });
    } catch (err) {
//      print(err);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishListCount = Provider.of<WishListModel>(context).products.length;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,/*
      floatingActionButton: (widget.user.username == config.adminEmail)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListChat(user: widget.user))); //
              },
              child: Icon(
                Icons.chat,
                size: 22,
              ),
            )
          : SmartChat(user: widget.user),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF0084C9),
            leading: IconButton(
              icon: Icon(
                Icons.blur_on,
                color: Colors.white70,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            expandedHeight: bannerHigh,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text("Setting",
                    style:
                        TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                background: Image.network(
                  kProfileBackground,
                  fit: BoxFit.cover,
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        leading: widget.user.picture != null
                            ? CircleAvatar(backgroundImage: NetworkImage(widget.user.picture))
                            : Icon(Icons.face),
                        title: Text(widget.user.name, style: TextStyle(fontSize: 16)),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(widget.user.email, style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 30.0),
                      Text("General Setting",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10.0),
                      Card(
                        margin: EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/profile/icon-heart.png',
                            width: 20,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text("My Wishlist", style: TextStyle(fontSize: 15)),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (wishListCount > 0)
                              Text(
                                "$wishListCount items",
                                style:
                                    TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
                              ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
                          ]),
                          onTap: () {
                            Navigator.pushNamed(context, "/wishlist");
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: SwitchListTile(
                          secondary: Image.asset(
                            'assets/icons/profile/icon-notify.png',
                            width: 25,
                            color: Theme.of(context).accentColor,
                          ),
                          value: enabledNotification,
                          activeColor: Color(0xFF0066B4),
                          onChanged: (bool value) {
                            if (value) {
                                NotificationPermissions
                                .requestNotificationPermissions(
                                    //const NotificationSettingsIos(sound: true, badge: true, alert: true)
                                ).then((_) {
                                    checkNotificationPermission();
                                });
                            }
                            setState(() {
                              enabledNotification = value;
                            });
                          },
                          title: Text(
                            "Get Notification",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      enabledNotification
                          ? Card(
                              margin: EdgeInsets.only(bottom: 2.0),
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Notifications()));
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.list,
                                    size: 24,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  title: Text("List Messages"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: kGrey600,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      enabledNotification
                          ? Divider(
                              color: Colors.black12,
                              height: 1.0,
                              indent: 75,
                              //endIndent: 20,
                            )
                          : Container(),/*
                      Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: SwitchListTile(
                          secondary: Icon(
                            Icons.dashboard,
                            color: Theme.of(context).accentColor,
                            size: 24,
                          ),
                          value: Provider.of<AppModel>(context).darkTheme,
                          activeColor: Color(0xFF0066B4),
                          onChanged: (bool value) {
                            if (value) {
                              Provider.of<AppModel>(context).updateTheme(true);
                            } else
                              Provider.of<AppModel>(context).updateTheme(false);
                          },
                          title: Text(
                            "Dark Theme",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),*/
                      SizedBox(height: 30.0),
                      Text("Order Detail",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 2.0),
                          elevation: 0,
                          child: ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Theme.of(context).accentColor,
                              size: 24,
                            ),
                            title: Text("Order History", style: TextStyle(fontSize: 16)),
                            trailing: Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            AppReview.requestReview.then((String onValue) {
                              setState(() {
                                output = onValue;
                              });
                              //print(onValue);
                            });
                            //_rateMyApp.showRateDialog(context).then((v) => setState(() {}));
                          },
                          leading: Image.asset(
                            'assets/icons/profile/icon-star.png',
                            width: 24,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text("Rate The App", style: TextStyle(fontSize: 16)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
                        ),
                      ),
                      Divider(
                        color: Colors.black12,
                        height: 1.0,
                        indent: 75,
                        //endIndent: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 2.0),
                        elevation: 0,
                        child: ListTile(
                          onTap: widget.onLogout,
                          leading: Image.asset(
                            'assets/icons/profile/icon-logout.png',
                            width: 24,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text("Logout", style: TextStyle(fontSize: 16)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
