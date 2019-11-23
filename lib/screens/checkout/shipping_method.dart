import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/user.dart';
import 'package:tashkentsupermarket/models/shipping_method.dart';

class ShippingMethods extends StatefulWidget {
  final Function onBack;
  final Function onNext;
  ShippingMethods({this.onBack, this.onNext});

  @override
  _ShippingMethodsState createState() => _ShippingMethodsState();
}

class _ShippingMethodsState extends State<ShippingMethods> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final address = Provider.of<CartModel>(context).address;
      final token = Provider.of<UserModel>(context).user != null ? Provider.of<UserModel>(context).user.cookie : null;
      Provider.of<ShippingMethodModel>(context).getShippingMethods(address: address, token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shippingMethodModel = Provider.of<ShippingMethodModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Shipping Method", style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        ListenableProvider<ShippingMethodModel>.value(
          value: shippingMethodModel,
          child: Consumer<ShippingMethodModel>(builder: (context, model, child) {
            if (model.isLoading) {
              return Container(
                height: 100,
                child: kLoadingWidget(context)
              );
            }

            if (model.message != null) {
              return Container(
                height: 100,
                child: Center(child: Text(model.message, style: TextStyle(color: kErrorRed))),
              );
            }

            return Column(
              children: <Widget>[
                for (int i = 0; i < model.shippingMethods.length; i++)
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: i == selectedIndex ? Theme.of(context).primaryColorLight : Colors.transparent),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: i,
                                  groupValue: selectedIndex,
                                  onChanged: (i) {
                                    setState(() {
                                      selectedIndex = i;
                                    });
                                  }),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(model.shippingMethods[i].title,
                                        style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                                    SizedBox(height: 5),
                                    Text(model.shippingMethods[i].description,
                                        style: TextStyle(fontSize: 14, color: kGrey400))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      i < model.shippingMethods.length - 1 ? Divider(height: 1) : Container()
                    ],
                  )
              ],
            );
          }),
        ),
        SizedBox(height: 20),
        Row(children: [
          Expanded(
            child: ButtonTheme(
              height: 45,
              child: RaisedButton(
                onPressed: () {
                  if (shippingMethodModel.shippingMethods.length > 0) {
                    Provider.of<CartModel>(context)
                        .setShippingMethod(shippingMethodModel.shippingMethods[selectedIndex]);
                    widget.onNext();
                  }
                },
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Text("Continue to Review".toUpperCase()),
              ),
            ),
          ),
        ]),
        Center(
            child: FlatButton(
                onPressed: () {
                  widget.onBack();
                },
                child: Text("Go back to address",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 15, color: kGrey400))))
      ],
    );
  }
}
