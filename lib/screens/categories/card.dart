import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/common/styles.dart';
import 'package:tashkentsupermarket/common/tools.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/widgets/tree_view.dart';

class CardCategories extends StatelessWidget {
  final List<Category> categories;

  CardCategories(this.categories);

  bool hasChildren(id) {
    return categories.where((o) => o.parent == id).toList().length > 0;
  }

  List<Category> getSubCategories(id) {
    return categories.where((o) => o.parent == id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _categories = categories.where((item) => item.parent == 0).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          TreeView(
            parentList: [
              for (var item in _categories)
                Parent(
                  parent: CategoryCardItem(item, hasChildren: hasChildren(item.id)),
                  childList: ChildList(
                    children: [
                      for (var category in getSubCategories(item.id))
                        Parent(
                            parent: SubItem(category),
                            childList: ChildList(
                              children: [
                                for (var cate in getSubCategories(category.id))
                                  Parent(
                                      parent: SubItem(cate, isLast: true),
                                      childList: ChildList(
                                        children: <Widget>[],
                                      ))
                              ],
                            ))
                    ],
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryCardItem extends StatelessWidget {
  final Category category;
  final bool hasChildren;

  CategoryCardItem(this.category, {this.hasChildren = false});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: hasChildren
          ? null
          : () {
              Product.showList(context: context, cateId: category.id, cateName: category.name);
            },
      child: Container(
        height: screenSize.width * 0.44,
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(bottom: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              child: Tools.image(
                url: category.image,
                fit: BoxFit.cover,
                width: screenSize.width,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Center(
                child: Text(
                  category.name.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubItem extends StatelessWidget {
  final Category category;
  final bool isLast;

  SubItem(this.category, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kGrey200))),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: isLast ? 50 : 20,
          ),
          Expanded(child: Text(category.name)),
          InkWell(
            onTap: () {
              Product.showList(context: context, cateId: category.id, cateName: category.name);
            },
            child: Text(
              "${category.totalProduct} items",
              style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ),
          IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                Product.showList(context: context, cateId: category.id, cateName: category.name);
              })
        ],
      ),
    );
  }
}


