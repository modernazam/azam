import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import "dart:core";
import 'package:http/http.dart' as http;

import 'index.dart';
import 'helper/woocommerce_api.dart';

import 'package:tashkentsupermarket/models/user.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/order.dart';
import 'package:tashkentsupermarket/models/review.dart';
import 'package:tashkentsupermarket/models/coupon.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/address.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/payment_method.dart';
import 'package:tashkentsupermarket/models/shipping_method.dart';

class WooCommerce implements BaseServices {
  WooCommerceAPI wcApi;
  String isSecure;
  String url;

  WooCommerce.appConfig(appConfig) {
    wcApi = WooCommerceAPI(appConfig["url"], appConfig["consumerKey"],
        appConfig["consumerSecret"]);
    isSecure = appConfig["url"].indexOf('https') != -1 ? '' : '&insecure=cool';
    url = appConfig["url"];
  }

  /// Get Nonce for Any Action
  Future getNonce({method = 'register'}) async {
    try {
      http.Response response = await http.get(
          "$url/api/get_nonce/?controller=user&method=$method&$isSecure",
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body)['nonce'];
      } else {
        throw Exception(['error getNonce', response.statusCode]);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      var response = await wcApi
          .getAsync("products/categories?&exclude=311&per_page=50");
      List<Category> list = [];
      for (var item in response) {
        list.add(Category.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      var response = await wcApi.getAsync("products");
      List<Product> list = [];
      for (var item in response) {
        list.add(Product.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Product>> fetchProductsLayout({config}) async {
    try {
      List<Product> list = [];

      var endPoint = "products?lang=en";
      if (config.containsKey("category")) {
        endPoint += "&category=${config["category"]}";
      }
      if (config.containsKey("tag")) {
        endPoint += "&tag=${config["tag"]}";
      }
      if (config.containsKey("page")) {
        endPoint += "&page=${config["page"]}";
      }
      if (config.containsKey("limit")) {
        endPoint += "&per_page=${config["limit"] ?? 10}";
      }

      var response = await wcApi.getAsync(endPoint);

      for (var item in response) {
        Product product = Product.fromJson(item);
        product.categoryId = config["category"];
        list.add(product);
      }
      return list;
    } catch (e) {
      //print('Error: ${e.toString()}');
      throw e;
    }
  }

  @override
  Future<List<Product>> fetchProductsByCategory(
      {categoryId, page, minPrice, maxPrice, orderBy, order}) async {
    try {
      List<Product> list = [];

      var endPoint = "products?&per_page=10&page=$page";
      if (categoryId != null) {
        endPoint += "&category=$categoryId";
      }
      if (minPrice != null) {
        endPoint += "&min_price=${(minPrice as double).toInt().toString()}";
      }
      if (maxPrice != null && maxPrice > 0) {
        endPoint += "&max_price=${(maxPrice as double).toInt().toString()}";
      }
      if (orderBy != null) {
        endPoint += "&orderby=$orderBy";
      }
      if (order != null) {
        endPoint += "&order=$order";
      }

      var response = await wcApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Product.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> loginFacebook({String token}) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint = "$url"+"api/user/fb_connect/?second=$cookieLifeTime&access_token=$token$isSecure";

      var response = await http.get(endPoint,
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      //print(endPoint + " " +response.body);
      /*
      print('token: $token$isSecure');
      print(endPoint + " " +response.body);*/
      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['status'] != 'ok') {
        return jsonDecode['msg'];
      }
      //print(jsonDecode);

      return User.fromJsonFB(jsonDecode);
    } catch (e) {
      //print(e.toString());
      throw e;
    }
  }

  @override
  Future<User> loginSMS({String token}) async {
    try {
      var endPoint =
          "$url/api/user/sms_login/?access_token=$token$isSecure";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      return User.fromJsonSMS(jsonDecode);
    } catch (e) {
//      print(e.toString());
      throw e;
    }
  }

  @override
  Future<List<Review>> getReviews(productId) async {
    try {
      var response = await wcApi.getAsync("products/$productId/reviews");
      List<Review> list = [];
      for (var item in response) {
        list.add(Review.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<ProductVariation>> getProductVariations(Product product) async {
    try {
      var response =
          await wcApi.getAsync("products/${product.id}/variations?per_page=20");
      List<ProductVariation> list = [];
      print('snapshot: ' + product.id.toString());
      for (var item in response) {
        list.add(ProductVariation.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token}) async {
    try {
      var response = await wcApi.getAsync("shipping_methods");
      List<ShippingMethod> list = [];
      for (var item in response) {
        list.add(ShippingMethod.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token}) async {
    try {
      var response = await wcApi.getAsync("payment_gateways");
      List<PaymentMethod> list = [];
      for (var item in response) {
        list.add(PaymentMethod.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Order>> getMyOrders({UserModel userModel}) async {
    try {
      var response = await wcApi
          .getAsync("orders?customer=${userModel.user.id}&per_page=20");
      List<Order> list = [];
      for (var item in response) {
        list.add(Order.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Order> createOrder({CartModel cartModel, UserModel user}) async {
    try {
      final params =
          Order().toJson(cartModel, user.user != null ? user.user.id : null);
      //print('orders: ' + params.toString());
      var response = await wcApi.postAsync("orders", params);
      //print('response: ' + response.toString());
      if (cartModel.shippingMethod == null) {
        response["shipping_lines"][0]["method_title"] = null;
      }
      if (response["message"] != null) {
        throw Exception(response["message"]);
      } else {
        return Order.fromJson(response);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future createPayment(data) async {
    try {
      final params = data;
      var response = await wcApi.payAsync(params);
      //print('response: ' + response.toString());
      if (response["xResult"] == "A") {
        updateOrderData(params["orderId"], {"status": "processing", "set_paid": true});
      }
      return response;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateOrderData(orderId, data) async {
    try {
      var response =
          await wcApi.putAsync("orders/$orderId", data);
      if (response["message"] != null) {
        throw Exception(response["message"]);
      } else {
        //print(response);
        return Order.fromJson(response);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateOrder(orderId, {status}) async {
    try {
      var response =
          await wcApi.putAsync("orders/$orderId", {"status": status});
      if (response["message"] != null) {
        throw Exception(response["message"]);
      } else {
//        print(response);
        return Order.fromJson(response);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Product>> searchProducts({name, page}) async {
    try {
      var response =
          await wcApi.getAsync("products?search=$name&page=$page&per_page=50");
      List<Product> list = [];
      for (var item in response) {
        list.add(Product.fromJson(item));
      }
      return list;
    } catch (e) {
      throw e;
    }
  }
  
  /// Auth
  @override
  Future<User> getUserInfo(cookie) async {
    try {
//      print("$url/api/user/get_currentuserinfo/?cookie=$cookie&$isSecure");

      final http.Response response = await http.get(
          "$url/api/user/get_currentuserinfo/?cookie=$cookie&$isSecure",
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      if (response.statusCode == 200) {
        return User.fromAuthUser(
            convert.jsonDecode(response.body)['user'], cookie);
      } else {
        throw Exception("Can not get user info");
      }
    } catch (err) {
      throw err;
    }
  }

  /// Create a New User
  @override
  Future<User> createUser({firstName, lastName, username, password}) async {
    try {
      String niceName = firstName + lastName;
      var nonce = await getNonce();
      final http.Response response = await http.get("$url/api/user/register/?insecure=cool&nonce=$nonce&username=$username&user_pass=$password&email=$username&user_nicename=$niceName&display_name=$niceName&$isSecure",
        headers: {'Content-Type': 'application/json; charset=utf-8'});
      if (response.statusCode == 200) {
        var cookie = convert.jsonDecode(response.body)['cookie'];
        return await this.getUserInfo(cookie);
      } else {
        var message = convert.jsonDecode(response.body)["error"];
        throw Exception(message != null ? message : "Can not create the user.");
      }
    } catch (err) {
      throw err;
    }
  }

  /// login
  @override
  Future<User> login({username, password}) async {
    var cookieLifeTime = 120960000000;
    try {
      final http.Response response = await http.get(
          "$url/api/user/generate_auth_cookie/?second=$cookieLifeTime&username=$username&password=$password&$isSecure",
          headers: {'Content-Type': 'application/json; charset=utf-8'});

      if (response.statusCode == 200) {
        var cookie = convert.jsonDecode(response.body)['cookie'];
        return await this.getUserInfo(cookie);
      } else {
        throw Exception("The username or password is incorrect.");
      }
    } catch (err) {
      throw err;
    }
  }

  Future<Stream<Product>> streamProductsLayout({config}) async {
    try {
      var endPoint = "products?per_page=10";
      if (config.containsKey("category")) {
        endPoint += "&category=${config["category"]}";
      }
      if (config.containsKey("tag")) {
        endPoint += "&tag=${config["tag"]}";
      }

      http.StreamedResponse response = await wcApi.getStream(endPoint);

      return response.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .expand((data) => (data as List))
          .map((data) => Product.fromJson(data));
    } catch (e) {
      print('Error: ${e.toString()}');
      throw e;
    }
  }

  @override
  Future<Product> getProduct(id) async {
    try {
      var response = await wcApi.getAsync("products/$id");
      return Product.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Coupons> getCoupons() async {
    try {
      var response = await wcApi.getAsync("coupons");
      //print(response.toString());
      return Coupons.getListCoupons(response);
    } catch (e) {
      throw e;
    }
  }
  
}
