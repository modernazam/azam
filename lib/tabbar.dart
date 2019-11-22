import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/screens/cart.dart';
import 'package:tashkentsupermarket/screens/categories/index.dart';
import 'package:tashkentsupermarket/screens/home.dart';
import 'package:tashkentsupermarket/screens/search/search.dart';
import 'package:tashkentsupermarket/screens/user.dart';

import 'models/user.dart';


class MainTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainTabsState();
  }
}

class MainTabsState extends State<MainTabs> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  int pageIndex = 0;
  int currentPage = 0;
  String currentTitle = "Home";
  Color currentColor = Colors.deepPurple;
  bool isAdmin = false;
  List<Widget> _tabView = [
    HomeScreen(),
    CategoriesScreen(),
    SearchScreen(),
    CartScreen(isModal: false),
    UserScreen()
  ];

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List getChildren(List<Category> categories, Category category) {
    List<Widget> list = [];
    var children = categories.where((o) => o.parent == category.id).toList();
    if (children.length == 0) {
      list.add(
        ListTile(
          leading: Padding(
            child: Text(category.name),
            padding: EdgeInsets.only(left: 20),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
          onTap: () {
            Product.showList(
                context: context, cateId: category.id, cateName: category.name);
          },
        ),
      );
    }
    for (var i in children) {
      list.add(
        ListTile(
          leading: Padding(
            child: Text(i.name),
            padding: EdgeInsets.only(left: 20),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
          onTap: () {
            Product.showList(context: context, cateId: i.id, cateName: i.name);
          },
        ),
      );
    }
    return list;
  }

  List showCategories() {
    final categories = Provider.of<CategoryModel>(context).categories;
    List<Widget> widgets = [];

    if (categories != null) {
      var list = categories.where((item) => item.parent == 0).toList();
      for (var index in list) {
        widgets.add(
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                index.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            children: getChildren(categories, index),
          ),
        );
      }
    }
    return widgets;
  }
  
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var totalCart = Provider.of<CartModel>(context).totalCartQuantity;
    bool loggedIn = Provider.of<UserModel>(context).loggedIn;
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    return Container(
        color: Theme.of(context).backgroundColor,
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _tabView,
            ),
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Row(
                        children: <Widget>[
                          Image.asset(kLogoImage, height: 60),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.shopping_basket,
                              size: 20,
                            ),
                            title: Text("Shop"),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, "/home");
                            },
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.heart, size: 20),
                            title: Text("My Wishlist"),
                            onTap: () {
                              Navigator.pushNamed(context, "/wishlist");
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.exit_to_app, size: 20),
                            title: loggedIn
                                ? Text("Logout")
                                : Text("LogIn"),
                            onTap: () {
                              loggedIn
                                  ? Provider.of<UserModel>(context).logout()
                                  : Navigator.pushNamed(context, "/login");
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              "By Category".toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.5),
                              ),
                            ),
                            children: showCategories(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: TabBar(
                tabs: [
                  Tab(
                    child: Image.asset(
                      "assets/icons/tabs/icon-home.png",
                      color: Theme.of(context).accentColor,
                      width: 24,
                    ),
                  ),
                  Tab(
                    child: Image.asset(
                      "assets/icons/tabs/icon-category.png",
                      color: Theme.of(context).accentColor,
                      width: 22,
                    ),
                  ),
                  Tab(
                    child: Image.asset(
                      "assets/icons/tabs/icon-search.png",
                      color: Theme.of(context).accentColor,
                      width: 23,
                    ),
                  ),
                  Tab(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 35,
                          padding: EdgeInsets.all(6.0),
                          child: Image.asset(
                            "assets/icons/tabs/icon-cart2.png",
                            color: Theme.of(context).accentColor,
                            width: 23,
                          ),
                        ),
                        if (totalCart > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                totalCart.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Tab(
                    child: Image.asset(
                      "assets/icons/tabs/icon-user.png",
                      color: Theme.of(context).accentColor,
                      width: 24,
                    ),
                  ),
                ],
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(4.0),
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ));
  }
}
