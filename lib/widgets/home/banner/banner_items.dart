import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:tashkentsupermarket/common/tools.dart';

/// The Banner type to display the image
class BannerImageItem extends StatefulWidget {
  final Key key;
  final config;
  final double width;
  final padding;
  final BoxFit boxFit;
  final radius;

  BannerImageItem({this.key, this.config, this.padding, this.width, this.boxFit, this.radius})
      : super(key: key);

  @override
  _BannerImageItemState createState() => _BannerImageItemState();
}

class _BannerImageItemState extends State<BannerImageItem> with AfterLayoutMixin {

  @override
  void afterFirstLayout(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    double _padding = widget.config["padding"] ?? widget.padding ?? 10.0;
    double _radius = widget.config['radius'] ?? (widget.radius != null ? widget.radius : 0.0);

    final screenSize = MediaQuery.of(context).size;
    final itemWidth = widget.width ?? screenSize.width;

    return GestureDetector(
      onTap: () => null,
      child: Container(
        width: itemWidth,
        child: Padding(
            padding: EdgeInsets.only(left: _padding, right: _padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Tools.image(
                fit: this.widget.boxFit ?? BoxFit.fitWidth,
                url: widget.config["image"]
              ),
            )),
      ),
    );
  }
}
