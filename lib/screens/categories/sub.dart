import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'package:tashkentsupermarket/widgets/product/product_list.dart';

class SubCategories extends StatefulWidget {
  final List<Category> categories;
  SubCategories(this.categories);

  @override
  State<StatefulWidget> createState() {
    return SubCategoriesState();
  }
}

class SubCategoriesState extends State<SubCategories> {
  int selectedIndex = 0;
  Services _service = Services();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(widget.categories[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            color: selectedIndex == index
                                ? theme.primaryColor
                                : theme.hintColor)),
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
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              return ProductList(
//                  isLoading: snapshot.connectionState == ConnectionState.none ||
//                      snapshot.connectionState == ConnectionState.active ||
//                      snapshot.connectionState == ConnectionState.waiting,
//                  errorMsg: snapshot.hasError ? snapshot.error : null,
                  products: snapshot.data);
            },
          ),
        )
      ],
    );
  }
}
