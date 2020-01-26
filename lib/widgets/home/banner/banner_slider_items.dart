import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tashkentsupermarket/widgets/home/banner/banner_items.dart';

/// The Banner Group type to display the image as multi columns
class BannerSliderItems extends StatefulWidget {

  BannerSliderItems();

  @override
  _StateBannerSlider createState() => _StateBannerSlider();
}

class _StateBannerSlider extends State<BannerSliderItems> {
  int position = 0;
  final List items = [
      {
        "category": 58,
        "image": "https://tashkentsupermarket.com/wp-content/uploads/2019/06/DSC_8453.jpg",
        "padding": 0.0
      },
      {
        "category": 69,
        "image": "https://tashkentsupermarket.com/wp-content/uploads/2019/06/IMG_0444.jpg",
        "padding": 0.0
      },
      {
        "category": 142,
        "image": "https://tashkentsupermarket.com/wp-content/uploads/2019/06/DSC_8445.jpg",
        "padding": 0.0
      }
  ];

  Widget getBannerPageView() {
      final screenSize = MediaQuery.of(context).size;
      PageController _controller = PageController();

      return Padding(
        child: PageIndicatorContainer(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              this.setState(() {
                position = index;
              });
            },
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                BannerImageItem(
                  config: items[i],
                  width: screenSize.width,
                  boxFit: BoxFit.cover,
                  padding: 0.0,
                  radius: 0.0,
                ),
            ],
          ),
          align: IndicatorAlign.bottom,
          length: items.length,
          indicatorSpace: 5.0,
          padding: const EdgeInsets.all(10.0),
          indicatorColor: Colors.black12,
          indicatorSelectorColor: Colors.black87,
          shape: IndicatorShape.roundRectangleShape(
            size: Size(25.0, 2.0),
          ),
        ),
        padding: EdgeInsets.only(top: 0, bottom: 5),
      );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double _bannerPercent = 0.36;

    return Container(
        height: screenSize.height * _bannerPercent,
        child: Stack(
          children: <Widget>[
            //HeaderText(),
            Align(
                  alignment:  Alignment.bottomCenter,
                  child: Container(
                    height: screenSize.height * _bannerPercent,
                    child: getBannerPageView(),
                  ),
                ),
            ],
        ));
  }
}
