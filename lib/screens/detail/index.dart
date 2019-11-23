import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/wishlist.dart';
import 'package:tashkentsupermarket/widgets/heart_button.dart';
import 'package:tashkentsupermarket/widgets/product/product_bottom_sheet.dart';

import 'image_feature.dart';
import 'product_description.dart';
import 'product_galery.dart';
import 'product_title.dart';
import 'product_variant.dart';
import 'related_product.dart';

class Detail extends StatefulWidget {
  final Product product;

  Detail({this.product});

  @override
  _DetailState createState() => _DetailState(product: product);
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  final _scrollController = new ScrollController();
  Product product;

  _DetailState({this.product});

  Map<String, String> mapAttribute = HashMap();
  AnimationController _controller;
  AnimationController _hideController;

  var top = 0.0;

  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  void showOptions(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  title: Text("My Cart", textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.of(context).pop();
                    _controller.forward();
                  }),
              ListTile(
                  title: Text("Save To Wishlist", textAlign: TextAlign.center),
                  onTap: () {
                    Provider.of<WishListModel>(context).addToWishlist(product);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  title: Text("Share", textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.of(context).pop();
                    Share.share(product.permalink);
                  }),
              Container(
                height: 1,
                decoration: BoxDecoration(color: kGrey200),
              ),
              ListTile(
                title: Text(
                  "Cancel",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final widthHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        bottom: false,
        top: kProductDetail["safeArea"] ?? false,
        child: ChangeNotifierProvider(
          builder: (_) => ProductModel(),
          child: Stack(
            children: <Widget>[
              Scaffold(
                floatingActionButton: Container(),
                backgroundColor: Theme.of(context).backgroundColor,
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      elevation: 1.0,
                      expandedHeight: widthHeight * kProductDetail['height'],
                      pinned: true,
                      floating: false,
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: kGrey400,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: <Widget>[
                        HeartButton(
                          product: product,
                          size: 20.0,
                          color: kGrey400,
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          color: kGrey400,
                          onPressed: () => showOptions(context),
                        ),
                      ],
                      flexibleSpace: ImageFeature(product),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          ProductGalery(product),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ProductTitle(product),
                                ProductVariant(product),
                                ProductDescription(product),
                                RelatedProduct(product),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Align(
                    child: ExpandingBottomSheet(
                        hideController: _hideController,
                        onInitController: (controller) {
                          setState(() {
                            _controller = controller;
                          });
                        }),
                    alignment: Alignment.bottomRight),
              )
            ],
          ),
        ),
      ),
    );
  }
}
