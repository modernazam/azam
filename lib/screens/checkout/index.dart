import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/models/order.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'payment.dart';
import 'review.dart';
import 'shipping_address.dart';
import 'shipping_method.dart';
import 'success.dart';

class Checkout extends StatefulWidget {
  final PageController controller;
  final bool isModal;

  Checkout({this.controller, this.isModal});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int tabIndex = 0;
  Order newOrder;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => widget.controller.animateToPage(
                  0,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
          ),
        ),
        actions: <Widget>[
          if (widget.isModal != null)
            IconButton(
              icon: Icon(Icons.close, size: 24),
              onPressed: () {
                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: newOrder != null
                    ? OrderedSuccess(order: newOrder)
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tabIndex = 0;
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 13),
                                        child: Text(
                                          "Address".toUpperCase(),
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      tabIndex >= 0
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(2.0),
                                                  bottomLeft: Radius.circular(2.0)),
                                              child: Container(
                                                  height: 3.0,
                                                  color: Theme.of(context).accentColor),
                                            )
                                          : Divider(height: 2, color: Theme.of(context).accentColor)
                                    ],
                                  ),
                                ),
                              ),
                              kAdvanceConfig['EnableShipping'] ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (cartModel.address != null && cartModel.address.isValid()) {
                                      setState(() {
                                        tabIndex = 1;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 13),
                                        child: Text(
                                          "Shipping".toUpperCase(),
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      tabIndex >= 1
                                          ? Container(height: 3.0, color: Theme.of(context).accentColor)
                                          : Divider(height: 2, color: Theme.of(context).accentColor)
                                    ],
                                  ),
                                ),
                              ) : Container(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (cartModel.shippingMethod != null) {
                                      setState(() {
                                        tabIndex = 2;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 13),
                                        child: Text("Review".toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                      tabIndex >= 2
                                          ? Container(height: 3.0, color: Theme.of(context).accentColor)
                                          : Divider(height: 2, color: Theme.of(context).accentColor)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (cartModel.shippingMethod != null) {
                                      setState(() {
                                        tabIndex = 3;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 13),
                                        child: Text("Payment".toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                      tabIndex >= 3
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(2.0),
                                                  bottomRight: Radius.circular(2.0)),
                                              child: Container(
                                                  height: 3.0,
                                                  color: Theme.of(context).accentColor),
                                            )
                                          : Divider(height: 2, color: Theme.of(context).accentColor)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              children: <Widget>[renderContent()],
                            ),
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderContent() {
    switch (tabIndex) {
      case 0:
        return ShippingAddress(onNext: () {
          Future.delayed(Duration.zero, () {
            setState(() {
              if (kAdvanceConfig['EnableShipping']){
                tabIndex = 1;
              } else {
                tabIndex = 2;
              }
            });
          });
        });
      case 1:
        return ShippingMethods(onBack: () {
          setState(() {
            tabIndex -= 1;
          });
        }, onNext: () {
          setState(() {
            tabIndex = 2;
          });
        });
      case 2:
        return Review(onBack: () {
          setState(() {
            tabIndex -= 1;
          });
        }, onNext: () {
          setState(() {
            tabIndex = 3;
          });
        });
      case 3:
      default:
        return PaymentMethods(onBack: () {
          setState(() {
            tabIndex -= 1;
          });
        }, onFinish: (order) {
          setState(() {
            newOrder = order;
          });
          Provider.of<CartModel>(context).clearCart();
        });
    }
  }
}
