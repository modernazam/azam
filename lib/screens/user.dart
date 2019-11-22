import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/models/user.dart';

import 'login.dart';
import 'settings.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  //final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return ListenableProvider(
        builder: (_) => userModel,
        child: Consumer<UserModel>(builder: (context, value, child) {

          if (value.user != null) {
            return SettingScreen(
              user: value.user,
              onLogout: () async {
                userModel.logout();
                //_auth.signOut();
              },
            );
          }
          return LoginScreen();
        }));
  }
}
