import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/widgets/home/header/header_view.dart';
import 'package:tashkentsupermarket/widgets/home/vertical/menu_layout.dart';
import 'package:tashkentsupermarket/widgets/home/vertical/pinterest_layout.dart';
import 'package:tashkentsupermarket/widgets/home/vertical/vertical_layout.dart';


class VerticalLayout extends StatefulWidget {
  final config;

  VerticalLayout({this.config});

  @override
  _VerticalLayoutState createState() => _VerticalLayoutState();
}

class _VerticalLayoutState extends State<VerticalLayout> {
  Widget renderLayout() {
    switch (widget.config['layout']) {
      case 'menu':
        return MenuLayout(config: widget.config);
      case 'pinterest':
        return PinterestLayout(config: widget.config);
      default:
        return VerticalViewLayout(config: widget.config);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (widget.config["name"] != null)
          HeaderView(
            headerText: widget.config["name"] ?? '',
            showSeeAll: true,
            callback: () => Product.showList(
              context: context,
              config: widget.config,
            ),
          ),
        renderLayout()
      ],
    );
  }
}
