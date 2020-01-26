import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tashkentsupermarket/common/constants.dart';
import 'package:tashkentsupermarket/models/product.dart';

class WishListModel extends ChangeNotifier {
  WishListModel(){
    getLocalWishlist();
  }

  List<Product> products = [];

  List<Product> getWishList() => products;

  void addToWishlist(Product product) {
    final isExist = products.firstWhere((item) => item.id == product.id, orElse: () => null);
    if (isExist == null) {
      products.add(product);
      saveWishlist(products);
      notifyListeners();
    }
  }

  void removeToWishlist(Product product) {
    final isExist = products.firstWhere((item) => item.id == product.id, orElse: () => null);
    if (isExist != null) {
      products = products.where((item) => item.id != product.id).toList();
      saveWishlist(products);
      notifyListeners();
    }
  }

  void saveWishlist(List<Product> products) async{
    final LocalStorage storage = new LocalStorage("fstore");
    try{
      final ready = await storage.ready;
      if(ready){
        await storage.setItem(kLocalKey["wishlist"], products);
      }
    }catch(err){
      print(err);
    }
  }

  void getLocalWishlist() async{
    final LocalStorage storage = new LocalStorage("fstore");
    try{
      final ready = await storage.ready;
      if(ready){
        final json = storage.getItem(kLocalKey["wishlist"]);
        if(json != null){
          List<Product> list = [];
          for(var item in json){
            list.add(Product.fromLocalJson(item));
          }
          products = list;
        }
      }
    }catch(err){
      print(err);
    }
  }
}
