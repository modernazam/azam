import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/search.dart';

import 'product_list.dart';
import 'recent_search.dart';

class SearchScreen extends StatefulWidget {
  final isModal;

  SearchScreen({this.isModal});

  @override
  _StateSearchScreen createState() => _StateSearchScreen();
}

class _StateSearchScreen extends State<SearchScreen> {
  bool isVisibleSearch = false;
  String searchText;
  var textController = new TextEditingController();
  Timer _timer;
  FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = new FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      isVisibleSearch = _focus.hasFocus;
    });
  }

  Widget _renderSearchLayout() {
    return ListenableProvider<SearchModel>(
      builder: (_) => Provider.of<SearchModel>(context),
      child: Consumer<SearchModel>(builder: (context, model, child) {
        if (searchText == null || searchText.isEmpty) {
          return Padding(
            child: RecentSearches(
              onTap: (text) {
                setState(() {
                  searchText = text;
                });
                textController.text = text;
                FocusScope.of(context).requestFocus(new FocusNode()); //dismiss keyboard
                Provider.of<SearchModel>(context).searchProducts(name: text, page: 1);
              },
            ),
            padding: EdgeInsets.only(left: 10, right: 10),
          );
        }

        if (model.loading) {
          return kLoadingWidget(context);
        }

        if (model.errMsg != null && model.errMsg.isNotEmpty) {
          return Center(child: Text(model.errMsg, style: TextStyle(color: kErrorRed)));
        }

        if (model.products.length == 0) {
          return Center(child: Text("No Product"));
        }

        return Column(
          children: <Widget>[
            Container(
              height: 45,
              decoration: BoxDecoration(color: HexColor("#F9F9F9")),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                Text(
                  "We found ${model.products.length} products",
                )
              ]),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: ProductList(name: searchText, products: model.products),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isModal != null
          ? AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                ),
              ),
              title: Text(
                "Search",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            widget.isModal == null ?
              AnimatedContainer(
                height: isVisibleSearch ? 0 : 40,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("Search",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                duration: Duration(milliseconds: 250),
              ) : SizedBox(height: 10.0,),
            Row(children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.black45,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          focusNode: _focus,
                          onChanged: (text) {
                            if (_timer != null) {
                              _timer.cancel();
                            }
                            _timer = Timer(Duration(milliseconds: 500), () {
                              setState(() {
                                searchText = text;
                              });
                              Provider.of<SearchModel>(context).searchProducts(name: text, page: 1);
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).accentColor,
                            border: InputBorder.none,
                            hintText: "Search for Items",
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        width: (searchText == null || searchText.isEmpty) ? 0 : 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchText = "";
                              isVisibleSearch = false;
                            });
                            textController.text = "";
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          child: Center(
                            child: Text("Cancel", overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        duration: Duration(milliseconds: 200),
                      )
                    ],
                  ),
                ),
              ),
            ]),
            Expanded(child: _renderSearchLayout()),
          ],
        ),
      ),
    );
  }
}
