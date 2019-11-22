import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:tashkentsupermarket/common/config.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/widgets/expansion_info.dart';
import 'additional_information.dart';
import 'review.dart';

class ProductDescription extends StatelessWidget {
  final Product product;

  ProductDescription(this.product);

  @override
  Widget build(BuildContext context) {
    bool enableReview = serverConfig["type"] != "magento";

    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        ExpansionInfo(
            title: "Description",
            children: <Widget>[
              HtmlWidget(
                product.description,
                textStyle: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
            expand: true),
        if (enableReview) Container(height: 1, decoration: BoxDecoration(color: kGrey200)),
        if (enableReview)
          ExpansionInfo(
            title: "Read Reviews",
            children: <Widget>[
              Reviews(product.id),
            ],
          ),
        Container(height: 1, decoration: BoxDecoration(color: kGrey200)),
        ExpansionInfo(
          title: "Additional Information",
          children: <Widget>[
            AdditionalInformation(product),
          ],
        ),
      ],
    );
  }
}
