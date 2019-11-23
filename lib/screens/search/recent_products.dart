import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/search.dart';
import 'package:tashkentsupermarket/widgets/product/product_card_view.dart';

class Recent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<SearchModel>.value(
      value: Provider.of<SearchModel>(context),
      child: Consumer<SearchModel>(builder: (context, model, child) {
        if (model.products == null || model.products.isEmpty) {
          return Container();
        }
        return Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Expanded(
                  child: Text("Recents",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
//                FlatButton(
//                    onPressed: null,
//                    child: Text(
//                      S.of(context).seeAll,
//                      style: TextStyle(color: Colors.greenAccent, fontSize: 13),
//                    ))
              ],
            ),
            SizedBox(height: 10),
            Divider(
              height: 1,
              color: kGrey200,
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.width * 0.35 + 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var item in model.products)
                      ProductCard(item: item, width: MediaQuery.of(context).size.width * 0.35)
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}