import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'package:tashkentsupermarket/widgets/product/product_list.dart';


class SideMenuCategories extends StatefulWidget {
  final List<Category> categories;

  SideMenuCategories(this.categories);

  @override
  State<StatefulWidget> createState() {
    return SideMenuCategoriesState();
  }
}

class SideMenuCategoriesState extends State<SideMenuCategories> {
  int selectedIndex = 0;
  Services _service = Services();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Row(
      children: <Widget>[
        Container(
          width: 100,
          child: ListView.builder(
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: selectedIndex == index ? Colors.grey[100] : Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Center(
                      child: Text(
                        widget.categories[index] != null
                            ? widget.categories[index].name.toUpperCase()
                            : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedIndex == index ? theme.primaryColor : theme.hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _service.fetchProductsByCategory(
                categoryId: widget.categories[selectedIndex].id),
            builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              return ProductList(
                products: snapshot.data,
                width: screenSize.width - 100,
                padding: 4.0,
                layout: "list",
              );
            },
          ),
        )
      ],
    );
  }
}
