import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/credit_card_model.dart';
import 'package:tashkentsupermarket/models/order.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'package:tashkentsupermarket/widgets/credit_card_form.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  final VoidCallback onRefresh;

  OrderDetail({this.order, this.onRefresh});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final services = Services();
  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text("Order No." + " #${widget.order.number}"),
          backgroundColor: kGrey200,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              for (var item in widget.order.lineItems)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: Text(item.name)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("x${item.quantity}"),
                      SizedBox(width: 20),
                      Text(Tools.getCurrecyFormatted(item.total),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              Container(
                decoration: BoxDecoration(color: kGrey200),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Subtotal"),
                        Text(
                          Tools.getCurrecyFormatted(widget.order.lineItems
                              .fold(0, (sum, e) => sum + double.parse(e.total))),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    (widget.order.shippingMethodTitle != null && kAdvanceConfig['EnableShipping']) ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Shipping Method"),
                        Text(
                          widget.order.shippingMethodTitle,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        )
                      ],
                    ) : Container(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Total"),
                        Text(
                          Tools.getCurrecyFormatted(widget.order.total),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    widget.order.status.toUpperCase(),
                    style: TextStyle(
                        color: kOrderStatusColor[widget.order.status] != null
                            ? HexColor(kOrderStatusColor[widget.order.status])
                            : Colors.black,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(height: 15),
              Stack(children: <Widget>[
                Container(
                  height: 6,
                  decoration:
                      BoxDecoration(color: kGrey200, borderRadius: BorderRadius.circular(3)),
                ),
                if (widget.order.status == "processing")
                  Container(
                    height: 6,
                    width: 200,
                    decoration: BoxDecoration(
                        color: kOrderStatusColor[widget.order.status] != null
                            ? HexColor(kOrderStatusColor[widget.order.status])
                            : Colors.black,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                if (widget.order.status != "processing")
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: kOrderStatusColor[widget.order.status] != null
                            ? HexColor(kOrderStatusColor[widget.order.status])
                            : Colors.black,
                        borderRadius: BorderRadius.circular(3)),
                  ),
              ]),
              SizedBox(height: 40),
              Text("Shipping Address",
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              if(widget.order.billing != null)
              Text(widget.order.billing.street +
                  ", " +
                  widget.order.billing.city +
                  ", " +
                  getCountryName(widget.order.billing.country)),
              if (widget.order.status == "pending")
                Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      CreditCardForm(
                          onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonTheme(
                              height: 45,
                              child: RaisedButton(
                                  textColor: Colors.white,
                                  color: HexColor("#08d52f"),
                                  onPressed: () {
                                    paymentOrder();
                                  },
                                  child: Text("Payment".toUpperCase(),
                                      style: TextStyle(fontWeight: FontWeight.w700))),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
              if (widget.order.status == "pending")
                Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonTheme(
                            height: 45,
                            child: RaisedButton(
                                textColor: Colors.white,
                                color: HexColor("#056C99"),
                                onPressed: () {
                                  refundOrder();
                                },
                                child: Text("Refund Request".toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w700))),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                )
            ],
          ),
        ));
  }

  String getCountryName(country) {
    try {
      return CountryPickerUtils.getCountryByIsoCode(country).name;
    } catch (err) {
      return country;
    }
  }

  void refundOrder() async {
    _showLoading();
    try {
      await services.updateOrder(widget.order.id, status: "refunded");
      _hideLoading();
      widget.onRefresh();
      Navigator.of(context).pop();
    } catch (err) {
      _hideLoading();

      final snackBar = SnackBar(
        content: Text(err.toString()),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void paymentOrder() async {
    if (cardNumber.length == 19 && cvvCode.length == 3 && expiryDate.length == 5) {
      _showLoading();
      try {
        Map<String, dynamic> cardJson = {
          'number': cardNumber.split(" ").join("").toString(),
          'cvv': cvvCode.toString(),
          'exp': expiryDate.substring(0, 2).toString() + expiryDate.substring(3, 5).toString(),
          "orderId": widget.order.id,
          "total": widget.order.total
        };

        final payment = await services.createPayment(cardJson);
        print(payment["xError"]);
        _hideLoading();
        if (payment["xResult"] != "A") {
          final snackBar = SnackBar(
            content: Text(payment["xError"].toString()),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
        widget.onRefresh();
        //Navigator.of(context).pop();
      } catch (err) {
        _hideLoading();
      }
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cvvCode = creditCardModel.cvvCode;
    });
  }

  void _showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new Center(
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white30, borderRadius: new BorderRadius.circular(5.0)),
                  padding: new EdgeInsets.all(50.0),
                  child: kLoadingWidget(context)));
        });
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }
}
