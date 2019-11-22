import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'package:tashkentsupermarket/widgets/product/product_card_view.dart';

import 'product_select_card.dart';

class MenuLayout extends StatefulWidget {
  final config;

  MenuLayout({this.config});

  @override
  _StateSelectLayout createState() => _StateSelectLayout();
}

class _StateSelectLayout extends State<MenuLayout> {
  int position = 0;
  bool loading = false;
  List<List<Product>> products = [];
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getAllListProducts(
      {minPrice, maxPrice, orderBy, order, page = 1, categories}) async {
    if (this.products.length > 0) return true;
    List<List<Product>> products = [];
    Services _service = Services();
    for (var category in categories) {
      var product = await _service.fetchProductsByCategory(
          categoryId: category.id,
          minPrice: minPrice,
          maxPrice: maxPrice,
          orderBy: orderBy,
          order: order,
          page: page);
      products.add(product);
      setState(() {
        this.products = products;
      });
    }
    return true;
  }

  Future<List<Category>> getAllCategory() async {
    final categories = Provider.of<CategoryModel>(context).categories;
    var listCategories = categories.where((item) => item.parent == 0).toList();
    List<Category> _categories = [];
    for (var category in listCategories) {
      var children = categories.where((o) => o.parent == category.id).toList();
      if (children.length > 0) {
        _categories = [..._categories, ...children];
      } else
        _categories = [..._categories, category];
    }
    return _categories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getAllCategory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return Column(
          children: <Widget>[
            Container(
              height: 70,
              padding: EdgeInsets.only(top: 15),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(snapshot.data.length, (index) {
                  bool check = (products.length > index)
                      ? (products[index].length < 1 ? false : true)
                      : true;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        position = index;
                      });
                    },
                    child: !check
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  child: Text(
                                    snapshot.data[index].name.toUpperCase(),
                                    style: TextStyle(
                                        color: index == position
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  padding: EdgeInsets.only(bottom: 8),
                                ),
                                index == position
                                    ? Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).primaryColor),
                                        width: 20,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                  );
                }),
              ),
            ),
            FutureBuilder<bool>(
              future: getAllListProducts(categories: snapshot.data),
              builder: (context, check) {
                if (products.length < 1)
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    key: Key(snapshot.data[position].id.toString()),
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: 4,
                    itemBuilder: (context, value) {
                      return ProductCard(
                        item: Product.empty(value),
                        width: MediaQuery.of(context).size.width / 2,
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                  );
                if (products[position].length == 0) {
                  return Container(
                    height: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Text("No Product"),
                    ),
                  );
                }
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    key: Key(snapshot.data[position].id.toString()),
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: products[position].length,
                    itemBuilder: (context, value) {
                      return ProductSelectCard(
                        item: products[position][value],
                        width: MediaQuery.of(context).size.width / 2,
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
