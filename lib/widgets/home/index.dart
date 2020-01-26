
import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/widgets/home/banner/banner_slider_items.dart';
import 'package:tashkentsupermarket/widgets/home/logo.dart';
import 'package:tashkentsupermarket/widgets/home/product_list_layout.dart';
import 'package:tashkentsupermarket/widgets/home/vertical.dart';

class HomeLayout extends StatefulWidget {

  HomeLayout();

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with AutomaticKeepAliveClientMixin {
      
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () => Future.delayed(
        Duration(milliseconds: 1000),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Logo(),
            BannerSliderItems(),
            ProductListLayout(config: { 
                  "name": "Bakery Collections",
                  "image": "",
                  "layout": "threeColumn",
                  "category": 58
                }),
            ProductListLayout(config: { 
                  "name": "Cold Food Collections",
                  "image": "",
                  "layout": "threeColumn",
                  "category": 69
                }),
            ProductListLayout(config: { 
                  "name": "Hot Food Collections",
                  "image": "",
                  "layout": "twoColumn",
                  "category": 142
                }),
            VerticalLayout(config: {
                "layout": "pinterest",
                "name": "Recent Collections",
                "image": "",
                "page": 0
              })
          ],
        ),
      ),
    );
  }
}