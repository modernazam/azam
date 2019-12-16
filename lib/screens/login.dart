import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/user.dart';
import 'package:tashkentsupermarket/screens/registration.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatefulWidget {
  final bool fromCart;

  LoginScreen({this.fromCart = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String username, password;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var parentContext;
  final _auth = FirebaseAuth.instance;

  void _welcomeMessage(user, context) {
    if (widget.fromCart) {
      Navigator.of(context).pop(user);
    } else {
      final snackBar = SnackBar(content: Text("Welcome" + ' ${user.name} !'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: Text('Warning: $message'),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;

    String forgetPasswordUrl = serverConfig['forgetPassword'];

    Future launchForgetPassworldURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: true, forceWebView: true);
      } else {}
    }

    _login(context) async {
      if (username == null || password == null) {
        var snackBar = SnackBar(content: Text("Please input fill in all fields"));
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Provider.of<UserModel>(context).login(
          username: username.trim(),
          password: password.trim(),
          success: (user) {
            _welcomeMessage(user, context);
            _auth
                .signInWithEmailAndPassword(email: username, password: password)
                .catchError((onError) {
              if (onError.code == 'ERROR_USER_NOT_FOUND')
                _auth.createUserWithEmailAndPassword(email: username, password: password).then((_) {
                  _auth.signInWithEmailAndPassword(email: username, password: password);
                });
            });
          },
          fail: (message) => _failMessage(message, context),
        );
      }
    }

    _loginFacebook(context) async {
      Provider.of<UserModel>(context).loginFB(
        success: (user) => _welcomeMessage(user, context),
        fail: (message) => _failMessage(message, context),
      );
    }

    _loginSMS(context) async {
      Provider.of<UserModel>(context).loginSMS(
        success: (user) => _welcomeMessage(user, context),
        fail: (message) => _failMessage(message, context),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop())
                Navigator.of(context).pop();
              else
                Navigator.of(context).pushNamed('/home');
            }),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
      ),

      body: SafeArea(
        child: Builder(
          builder: (context) => Stack(children: [
            ListenableProvider<UserModel>.value(
              value: Provider.of<UserModel>(context),
              child: Consumer<UserModel>(builder: (context, model, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(height: 70.0, child: Image.asset('assets/images/logo.png')),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 60.0),
                      /*
                      TextField(
                          controller: _usernameController,
                          onChanged: (value) => username = value,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          )),*/
                      TextField(
                        controller: _usernameController,
                        onChanged: (value) => username = value,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            InputDecoration(labelText: 'Enter your email'),
                      ),

                      const SizedBox(height: 12.0),
                      Stack(children: <Widget>[
                        TextField(
                          onChanged: (value) => password = value,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 20,
                          child: GestureDetector(
                            child: Text(
                              " " + "Reset",
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              launchForgetPassworldURL(forgetPasswordUrl);
                            },
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 60.0,
                      ),
                      SignInButtonBuilder(
                        text: "Sign In With Email",
                        icon: Icons.email,
                        onPressed: () {
                          _login(context);
                        },
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Stack(alignment: AlignmentDirectional.center, children: <Widget>[
                        SizedBox(
                            height: 60.0,
                            width: 200.0,
                            child: Divider(color: Colors.grey.shade300)),
                        Container(height: 30, width: 40, color: Colors.white),
                        Text("OR",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400))
                      ]),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () => _loginFacebook(context),
                            child: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Color(0xFF4267B2),
                              size: 24.0,
                            ),
                            shape: CircleBorder(),
                            elevation: 0.4,
                            fillColor: Colors.grey.shade50,
                            padding: const EdgeInsets.all(15.0),
                          ),/*
                          RawMaterialButton(
                            onPressed: () => _loginSMS(context),
                            child: Icon(
                              FontAwesomeIcons.googlePlusG,
                              color: HexColor('#dd4b39'),
                              size: 24.0,
                            ),
                            shape: CircleBorder(),
                            elevation: 0.4,
                            fillColor: Colors.grey.shade50,
                            padding: const EdgeInsets.all(15.0),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => RegistrationScreen(),
                                    ),
                                  );
                                },
                                child: Text(" Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),

//            FlatButton(
//              child: const Text('CANCEL'),
//              shape: const BeveledRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(7.0)),
//              ),
//              onPressed: () {
//                _usernameController.clear();
//                _passwordController.clear();
//                Navigator.pop(context);
//              },
//            ),
                    ],
                  ),
                );
              }),
            ),
//            if (widget.fromCart)
//              Positioned(
//                  left: 10,
//                  child: IconButton(
//                      icon: Icon(
//                        Icons.close,
//                        color: Colors.black,
//                      ),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      })),
          ]),
        ),
      ),
    );
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child}) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
