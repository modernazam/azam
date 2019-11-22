import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/screens/detail/index.dart';
import 'package:tashkentsupermarket/widgets/start_rating.dart';


class PinterestCard extends StatelessWidget {
  final Product item;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final bool showCart;
  final bool showHeart;
  final bool showOnlyImage;

  PinterestCard(
      {this.item,
      this.width,
      this.size = kSize.medium,
      this.isHero = false,
      this.showHeart = true,
      this.showCart = false,
      this.showOnlyImage = false,
      this.marginRight = 10.0});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final addProductToCart = Provider.of<CartModel>(context).addProductToCart;
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    double titleFontSize = isTablet ? 20.0 : 14.0;
    double iconSize = isTablet ? 24.0 : 18.0;
    double starSize = isTablet ? 20.0 : 13.0;

    void onTapProduct() {
      if (item.imageFeature == '') return;

      Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Detail(product: item),
            fullscreenDialog: true,
          ));
    }

    return GestureDetector(
      onTap: onTapProduct,
      child: Container(
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Tools.image(
              url: item.imageFeature,
              width: width,
              size: kSize.medium,
              isResize: true,
              fit: BoxFit.fill,
            ),
            if (showOnlyImage == null || !showOnlyImage )
              Container(
                width: width,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 20),
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
    );
  }
}
