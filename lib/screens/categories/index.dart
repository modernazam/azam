import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/screens/categories/card.dart';
import 'package:tashkentsupermarket/screens/categories/column.dart';
import 'package:tashkentsupermarket/screens/categories/side_menu.dart';
import 'package:tashkentsupermarket/screens/categories/sub.dart';
import 'package:tashkentsupermarket/widgets/cardlist/index.dart';
import 'package:tashkentsupermarket/widgets/grid_category.dart';



class CategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesScreenState();
  }
}

class CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  FocusNode _focus;
  bool isVisibleSearch = false;
  String searchText;
  var textController = new TextEditingController();

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(controller);
    animation.addListener(() {
      setState(() {});
    });

    _focus = new FocusNode();
    _focus.addListener(_onFocusChange);

    Future.delayed(Duration.zero, () {
      Provider.of<CategoryModel>(context).getCategories();
    });
  }

  void _onFocusChange() {
    if (_focus.hasFocus && animation.value == 0) {
      controller.forward();
      setState(() {
        isVisibleSearch = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final category = Provider.of<CategoryModel>(context);

    return ListenableProvider(
        builder: (_) => category,
        child: Consumer<CategoryModel>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return kLoadingWidget(context);
            }

            if (value.message != null) {
              return Center(
                child: Text(value.message),
              );
            }

            if (value.categories == null) {
              return null;
            }

            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                  child: [
                kCategoriesLayout.grid,
                kCategoriesLayout.column,
                kCategoriesLayout.sideMenu,
                kCategoriesLayout.subCategories
              ].contains(CategoriesListLayout)
                      ? Column(
                          children: <Widget>[
                            Padding(
                              child: Text(
                                "Category",
                                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.only(top: 10, left: 10, bottom: 20, right: 10),
                            ),
                            Expanded(
                              child: renderCategories(value),
                            )
                          ],
                        )
                      : ListView(
                          children: <Widget>[
                            Padding(
                              child: Text(
                                "Category",
                                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.only(top: 10, left: 10, bottom: 20, right: 10),
                            ),
                            renderCategories(value)
                          ],
                        )),
            );
          },
        ));
  }

  Widget renderCategories(value) {
    switch (CategoriesListLayout) {
      case kCategoriesLayout.card:
        return CardCategories(value.categories);
      case kCategoriesLayout.column:
        return ColumnCategories(value.categories);
      case kCategoriesLayout.subCategories:
        return SubCategories(value.categories);
      case kCategoriesLayout.sideMenu:
        return SideMenuCategories(value.categories);
      case kCategoriesLayout.animation:
        return HorizonMenu();
      case kCategoriesLayout.grid:
        return GridCategory();
      default:
        return CardCategories(value.categories);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
