import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/services/index.dart';

import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/recent_product.dart';

import 'package:tashkentsupermarket/widgets/home/header/header_view.dart';
import 'package:tashkentsupermarket/widgets/home/product_staggered.dart';
import 'package:tashkentsupermarket/widgets/product/product_card_view.dart';


class ProductListLayout extends StatefulWidget {
  final config;

  ProductListLayout({this.config});

  @override
  _ProductListItemsState createState() => _ProductListItemsState();
}

class _ProductListItemsState extends State<ProductListLayout> {
  final Services _service = Services();
  Future<List<Product>> _getProductLayout;

  final _memoizer = AsyncMemoizer<List<Product>>();

  @override
  void initState() {
    // only create the future once
    new Future.delayed(Duration.zero, () {
      _getProductLayout = getProductLayout(context);
    });
    super.initState();
  }

  double _buildProductWidth(screenWidth) {
    switch (widget.config["layout"]) {
      case "twoColumn":
        return screenWidth * 0.5;
      case "threeColumn":
        return screenWidth * 0.35;
      case "fourColumn":
        return screenWidth / 4;
      case "recentView":
        return screenWidth / 4;
      case "card":
      default:
        return screenWidth - 10;
    }
  }

  double _buildProductHeight(screenWidth, isTablet) {
    switch (widget.config["layout"]) {
      case "twoColumn":
      case "threeColumn":
      case "fourColumn":
      case "recentView":
        return screenWidth * 0.5;
        break;
      case "card":
      default:
        var cardHeight =
            widget.config["height"] != null ? widget.config["height"] + 40.0 : screenWidth * 1.4;
        return isTablet ? screenWidth * 1.3 : cardHeight;
        break;
    }
  }

  Future<List<Product>> getProductLayout(context) async {
    if (widget.config["layout"] == "recentView")
      return Provider.of<RecentModel>(context).products;
    return _memoizer.runOnce(
      () => _service.fetchProductsLayout(
          config: widget.config),
    );
  }

  Widget getProductListWidgets(List<Product> products) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _buildProductHeight(screenSize.width, isTablet),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 10.0),
            for (var item in products)
              ProductCard(
                item: item,
                //isHero: true,
                width: _buildProductWidth(screenSize.width),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    final recentProduct = Provider.of<RecentModel>(context).products;
    final isRecent = widget.config["layout"] == "recentView" ? true : false;

    if (isRecent && recentProduct.length < 3) return Container();

    return FutureBuilder<List<Product>>(
      future: _getProductLayout,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                HeaderView(
                  headerText: widget.config["name"],
                  showSeeAll: isRecent ? false : true,
                  callback: () => Product.showList(context: context, config: widget.config),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: _buildProductHeight(screenSize.width, isTablet),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 10.0),
                        for (var i = 0; i < 4; i++)
                          ProductCard(
                            item: Product.empty(i),
                            width: _buildProductWidth(screenSize.width),
                          )
                      ],
                    ),
                  ),
                )
              ],
            );
          case ConnectionState.done:
          default:
            if (snapshot.hasError || snapshot.data.length == 0) {
              return Container();
            } else {
              return Column(
                children: <Widget>[
                  HeaderView(
                    headerText: widget.config["name"],
                    showSeeAll: isRecent ? false : true,
                    callback: () => Product.showList(
                        context: context,                         
                        config: widget.config,
                        products: isRecent ? recentProduct : snapshot.data),
                  ),
                  widget.config["layout"] == "staggered"
                      ? ProductStaggered(snapshot.data)
                      : getProductListWidgets(snapshot.data)
                ],
              );
            }
        }
      },
    );
  }
}
