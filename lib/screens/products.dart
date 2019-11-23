import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tashkentsupermarket/models/app.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'package:tashkentsupermarket/widgets/asymmetric_view.dart';
import 'package:tashkentsupermarket/widgets/backdrop.dart';
import 'package:tashkentsupermarket/widgets/backdrop_menu.dart';
import 'package:tashkentsupermarket/widgets/product/product_bottom_sheet.dart';
import 'package:tashkentsupermarket/widgets/product/product_list.dart';

class ProductBackdrop extends StatelessWidget {
  final ExpandingBottomSheet expandingBottomSheet;
  final Backdrop backdrop;

  const ProductBackdrop({Key key, this.expandingBottomSheet, this.backdrop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backdrop,
        Align(child: expandingBottomSheet, alignment: Alignment.bottomRight)
      ],
    );
  }
}

class ProductsPage extends StatefulWidget {
  final List<Product> products;
  final int categoryId;
  final config;

  ProductsPage({
    this.products,
    this.categoryId,
    this.config,
  });

  @override
  State<StatefulWidget> createState() {
    return ProductsPageState();
  }
}

class ProductsPageState extends State<ProductsPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  int newCategoryId = -1;
  double minPrice;
  double maxPrice;
  String orderBy;
  String order;
  bool isFiltering = false;
  List<Product> products = [];
  String errMsg;

  @override
  void initState() {
    super.initState();
    setState(() {
      newCategoryId = widget.categoryId;
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: 1.0,
    );

    if (widget.config != null) {
      onRefresh();
    }
  }

  void onFilter({minPrice, maxPrice, categoryId}) {
    _controller.forward();
    final productModel = Provider.of<ProductModel>(context);
    newCategoryId = categoryId;
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    productModel.setProductsList(List<Product>());
    productModel.getProductsList(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: 1,
        orderBy: orderBy,
        order: order);
  }

  void onSort(order) {
    orderBy = "date";
    this.order = order;
    Provider.of<ProductModel>(context).getProductsList(
        categoryId: newCategoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: 1,
        orderBy: orderBy,
        order: order);
  }

  void onRefresh() async {
    if (widget.config == null) {
      Provider.of<ProductModel>(context).getProductsList(
          categoryId: newCategoryId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          page: 1,
          orderBy: orderBy,
          order: order);
    } else {
      try {
        var newProducts = await Services().fetchProductsLayout(config: widget.config);
        setState(() {
          products = newProducts;
        });
      } catch (err) {
        setState(() {
          errMsg = err;
        });
      }
    }
  }

  void onLoadMore(page) {
    Provider.of<ProductModel>(context).getProductsList(
        categoryId: newCategoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: page,
        orderBy: orderBy,
        order: order);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context);
    final title = product.categoryName ?? "Products";
    final layout = widget.config != null && widget.config["layout"] != null
        ? widget.config["layout"]
        : Provider.of<AppModel>(context).appConfig['Setting']['ProductListLayout'];
    final isListView = layout != 'horizontal';

    /// load the product base on default 2 columns view or AsymmetricView
    /// please note that the AsymmetricView is not ready support for loading per page.
    final backdrop = ({products, isFetching, errMsg, isEnd}) => ProductBackdrop(
          backdrop: Backdrop(
            frontLayer: isListView
                ? ProductList(
                    products: products,
                    onRefresh: onRefresh,
                    onLoadMore: onLoadMore,
                    isFetching: isFetching,
                    errMsg: errMsg,
                    isEnd: isEnd,
                    layout: layout)
                : AsymmetricView(products: widget.products),
            backLayer: BackdropMenu(onFilter: onFilter),
            frontTitle: Text(title),
            backTitle: Text('Filters'),
            controller: _controller,
            onSort: onSort,
          ),
          expandingBottomSheet: ExpandingBottomSheet(hideController: _controller),
        );

    return ListenableProvider.value(
      value: product,
      child: Consumer<ProductModel>(builder: (context, value, child) {
        return backdrop(
            products: value.productsList,
            isFetching: value.isFetching,
            errMsg: value.errMsg,
            isEnd: value.isEnd);
      }),
    );
  }
}
