import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/common/styles.dart';

class PaymentWebview extends StatefulWidget {
  final Map<String, dynamic> params;
  final Function onFinish;

  PaymentWebview({this.params, this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaymentWebviewState();
  }
}

class PaymentWebviewState extends State<PaymentWebview> {


  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("/checkout/order-received/")) {
        final items = url.split("/checkout/order-received/");
        if (items.length > 1) {
          final number = items[1].split("/")[0];
          widget.onFinish(number);
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var str = convert.jsonEncode(widget.params);
    var bytes = convert.utf8.encode(str);
    var base64Str = convert.base64.encode(bytes);

    final checkoutUrl = serverConfig['url'] + "checkout/?order=$base64Str";
    print('checkoutUrl: ' + checkoutUrl);
    return WebviewScaffold(
      url: checkoutUrl,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: kGrey200,
        elevation: 0.0,
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        child: kLoadingWidget(context)
      ),
    );
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () {
//              Navigator.of(context).pop();
//            }),
//        backgroundColor: kGrey200,
//        elevation: 0.0,
//      ),
//      body: WebView(
//          javascriptMode: JavascriptMode.unrestricted,
//          initialUrl: checkoutUrl,
//          onPageFinished: (String url) {
//            if(url.contains("/checkout/order-received/")){
//              final items = url.split("/checkout/order-received/");
//              if(items.length > 1){
//                final number = items[1].split("/")[0];
//                onFinish(number);
//                Navigator.of(context).pop();
//              }
//            }
//          }),
//    );
  }
}
