import 'package:flutter/material.dart';
import 'package:tashkentsupermarket/services/index.dart';
import 'product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchModel extends ChangeNotifier{
  SearchModel() {
    getKeywords();
  }

  List<String> keywords = [];
  List<Product> products = [];
  bool loading = false;
  String errMsg;

  void searchProducts({String name, page}) async {
    try{
      loading = true;
      notifyListeners();
      products = await Services().searchProducts(name: name, page: page);
      if(products.length > 0 && page == 1 && name.isNotEmpty){
        int index = keywords.indexOf(name);
        if(index > -1){
          keywords.removeAt(index);
        }
        keywords.insert(0, name);
        saveKeywords(keywords);
      }
      loading = false;
      notifyListeners();
    }catch(err){
      loading = false;
      errMsg = err.toString();
      notifyListeners();
    }
  }

  void clearKeywords(){
    keywords = [];
    saveKeywords(keywords);
    notifyListeners();
  }

  void saveKeywords(List<String> keywords) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList("recentSearches", keywords);
    }catch(err){
      print(err);
    }
  }

  getKeywords() async {
    try{
      //SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList("recentSearches");
      if(list != null && list.length > 0){
        keywords = list;
      }
    }catch(err){
      print(err);
    }
  }
}
