import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/wishlist.dart';
import 'package:tashkentsupermarket/widgets/product/product_bottom_sheet.dart';


class WishList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WishListState();
  }
}

class WishListState extends State<WishList> with SingleTickerProviderStateMixin {
  AnimationController _hideController;

  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 22,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("My Wishlist"),
            backgroundColor: Color(0xFFEBEBED)
        ),
        body: ListenableProvider.value(
            value: Provider.of<WishListModel>(context),
            child: Consumer<WishListModel>(builder: (context, model, child) {
              if (model.products.isEmpty) {
                return EmptyWishlist();
              } else {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Text("${model.products.length} " + "items",
                        style: TextStyle(fontSize: 14, color: kGrey400)),
                  ),
                  Divider(height: 1, color: kGrey200),
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                        itemCount: model.products.length,
                        itemBuilder: (context, index) {
                          return WishlistItem(
                              product: model.products[index],
                              onRemove: () {
                                Provider.of<WishListModel>(context)
                                    .removeToWishlist(model.products[index]);
                              },
                              onAddToCart: () {
                                Provider.of<CartModel>(context)
                                    .addProductToCart(product: model.products[index], quantity: 1);
                              });
                        }),
                  )
                ]);
              }
            })),
      ),
      Align(
          child: ExpandingBottomSheet(hideController: _hideController),
          alignment: Alignment.bottomRight)
    ]);
  }
}

class EmptyWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 80),
          Image.asset(
            'assets/images/empty_wishlist.png',
            width: 120,
            height: 120,
          ),
          SizedBox(height: 20),
          Text("No favourites yet.",
              style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
          SizedBox(height: 15),
          Text("Tap any heart next to a product to favotite. We’ll save them for you here!",
              style: TextStyle(fontSize: 14, color: kGrey900), textAlign: TextAlign.center),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: RaisedButton(
                      child: Text("Start Shopping".toUpperCase()),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 44,
                  child: RaisedButton(
                      child: Text("Search for Items".toUpperCase()),
                      color: kGrey200,
                      textColor: kGrey400,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class WishlistItem extends StatelessWidget {
  WishlistItem({@required this.product, this.onAddToCart, this.onRemove});

  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final localTheme = Theme.of(context);

    return Column(children: [
      Row(
        key: ValueKey(product.id),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: onRemove,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: screenSize.width * 0.25,
                        height: screenSize.width * 0.3,
                        child: Tools.image(url: product.imageFeature, size: kSize.medium),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: localTheme.textTheme.caption,
                            ),
                            SizedBox(height: 7),
                            Text(Tools.getCurrecyFormatted(product.price),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(color: kGrey400, fontSize: 14)),
                            SizedBox(height: 10),


                            RaisedButton(
                                textColor: Colors.white,
                                color: localTheme.primaryColor,
                                child: Text("Add To Cart".toUpperCase()),
                                onPressed: onAddToCart)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10.0),
      Divider(color: kGrey200, height: 1),
      SizedBox(height: 10.0),
    ]);
  }
}
