import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/order.dart';


class OrderedSuccess extends StatelessWidget {
  final Order order;

  OrderedSuccess({this.order});

  @override
  Widget build(BuildContext context) {
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(color: kGrey200),
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "It's ordered!",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Order No.",
                          style: TextStyle(fontSize: 14, color: kGrey900),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "#${order.number}",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                      ],
                    )
                  ])),
        ),
        SizedBox(height: 30),
        Text("You've successfully placed the order",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        SizedBox(height: 15),
        Text(
          "You can check status of your order by using our delivery status feature. You will receive an order confirmation e-mail with details of your order and a link to track its progress.",
          style: TextStyle(color: kGrey900, height: 1.4, fontSize: 14),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Row(children: [
            Expanded(
              child: ButtonTheme(
                height: 45,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed("/orders");
                  },
                  child: Text(
                    "Show All My Ordered".toUpperCase(),
                  ),
                ),
              ),
            ),
          ]),
        ),
        SizedBox(height: 40),
        Text("Your account", style: TextStyle(fontSize: 18, color: Colors.black)),
        SizedBox(height: 10),
        Text(
          "You can log to your account using e-mail and password defined earlier. On your account you can edit your profile data, check history of transactions, edit subscription to newsletter.",
          style: TextStyle(color: kGrey900, height: 1.4, fontSize: 14),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Row(children: [
            Expanded(
                child: ButtonTheme(
              height: 45,
              child: OutlineButton(
                  borderSide: BorderSide(color: Colors.black),
                  child: new Text("Back to Shop".toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/home");
                  },
                  shape: RoundedRectangleBorder()),
            )),
          ]),
        )
      ],
    );
  }
}
