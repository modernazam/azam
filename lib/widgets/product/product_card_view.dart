import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tashkentsupermarket/common/tools.dart';

import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/recent_product.dart';
import 'package:tashkentsupermarket/screens/detail/index.dart';
import 'package:tashkentsupermarket/widgets/heart_button.dart';
import 'package:tashkentsupermarket/widgets/start_rating.dart';


class ProductCard extends StatelessWidget {
  final Product item;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final bool showCart;
  final bool showHeart;
  final height;
  final bool hideDetail;

  ProductCard(
      {this.item,
      this.width,
      this.size = kSize.medium,
      this.isHero = false,
      this.showHeart = false,
      this.showCart = false,
      this.height,
      this.hideDetail = false,
      this.marginRight = 10.0});

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: isHero
          ? Hero(
              tag: 'product-${item.id}',
              child: Tools.image(
                url: item.imageFeature,
                width: width,
                size: kSize.medium,
                isResize: true,
                height: height ?? width * 1.2,
                fit: BoxFit.cover,
              ),
            )
          : Tools.image(
              url: item.imageFeature,
              width: width,
              size: kSize.medium,
              isResize: true,
              height: height ?? width * 1.2,
              fit: BoxFit.cover,
            ),
    );
  }

  onTapProduct(context) {
    if (item.imageFeature == '') return;
    Provider.of<RecentModel>(context).addRecentProduct(item);
    print('item id: ${item.id}');
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Detail(product: item),
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final addProductToCart = Provider.of<CartModel>(context).addProductToCart;
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    double titleFontSize = isTablet ? 20.0 : 14.0;
    double iconSize = isTablet ? 24.0 : 18.0;
    double starSize = isTablet ? 20.0 : 10.0;

    if (hideDetail)
      return getImageFeature(
        () => onTapProduct(context),
      );

    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.only(right: marginRight),
          child: Column(
            children: <Widget>[
              getImageFeature(() => onTapProduct(context)),
              Container(
                width: width,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.name,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1),
                    SizedBox(height: 6),
                    Text(Tools.getCurrecyFormatted(item.price),
                        style: TextStyle(color: theme.accentColor)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: item.averageRating ?? 0.0,
                            size: starSize,
                            color: theme.primaryColor,
                            borderColor: theme.primaryColor,
                            spacing: 0.0),
                        if (showCart && !item.isEmptyProduct())
                          IconButton(
                              padding: EdgeInsets.all(2.0),
                              icon: Icon(Icons.add_shopping_cart, size: iconSize),
                              onPressed: () {
                                addProductToCart(product: item);
                              }),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (showHeart && !item.isEmptyProduct())
          Positioned(
            top: 0,
            right: 0,
            child: HeartButton(product: item, size: 18),
          )
      ],
    );
  }
}
