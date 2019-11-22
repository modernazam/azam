
import 'package:connectivity/connectivity.dart';
import 'package:tashkentsupermarket/models/address.dart';
import 'package:tashkentsupermarket/models/cart.dart';
import 'package:tashkentsupermarket/models/category.dart';
import 'package:tashkentsupermarket/models/coupon.dart';
import 'package:tashkentsupermarket/models/order.dart';
import 'package:tashkentsupermarket/models/payment_method.dart';
import 'package:tashkentsupermarket/models/product.dart';
import 'package:tashkentsupermarket/models/review.dart';
import 'package:tashkentsupermarket/models/shipping_method.dart';
import 'package:tashkentsupermarket/models/user.dart';
import 'package:tashkentsupermarket/services/woo_commerce.dart';

abstract class BaseServices {
  
  Future<List<Category>> getCategories();

  Future<List<Product>> getProducts();
  
  Future<List<Product>> fetchProductsLayout({config});

  Future<List<Product>> fetchProductsByCategory(
      {categoryId, page, minPrice, maxPrice, orderBy, order});

  Future<User> loginFacebook({String token});

  Future<User> loginSMS({String token});

  Future<List<Review>> getReviews(productId);

  Future<List<ProductVariation>> getProductVariations(Product product);

  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token});

  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token});

  Future<Order> createOrder({CartModel cartModel, UserModel user});

  Future<List<Order>> getMyOrders({UserModel userModel});

  Future updateOrder(orderId, {status});

  Future<List<Product>> searchProducts({name, page});

  Future<User> getUserInfo(cookie);

  Future<User> createUser({
    firstName,
    lastName,
    username,
    password,
  });

  Future<User> login({username, password});

  Future<Product> getProduct(id);

  Future<Coupons> getCoupons();
  
}


class Services implements BaseServices {
  BaseServices serviceApi;

  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  void setAppConfig(appConfig) {
    switch (appConfig["type"]) {
      default:
        serviceApi = WooCommerce.appConfig(appConfig);
    }
  }

  @override
  Future<List<Product>> fetchProductsByCategory(
      {categoryId, page = 1, minPrice, maxPrice, orderBy, order}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.fetchProductsByCategory(
          categoryId: categoryId,
          page: page,
          minPrice: minPrice,
          maxPrice: maxPrice,
          orderBy: orderBy,
          order: order);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> fetchProductsLayout({config}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.fetchProductsLayout(config: config);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCategories();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProducts();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> loginFacebook({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.loginFacebook(token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> loginSMS({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.loginSMS(token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Review>> getReviews(productId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getReviews(productId);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<ProductVariation>> getProductVariations(Product product) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductVariations(product);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getShippingMethods(address: address, token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getPaymentMethods(
          address: address, shippingMethod: shippingMethod, token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Order>> getMyOrders({UserModel userModel}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getMyOrders(userModel: userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Order> createOrder({CartModel cartModel, UserModel user}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createOrder(cartModel: cartModel, user: user);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future updateOrder(orderId, {status}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateOrder(orderId, status: status);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> searchProducts({name, page}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.searchProducts(name: name, page: page);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> createUser({firstName, lastName, username, password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
      );
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> getUserInfo(cookie) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getUserInfo(cookie);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> login({username, password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.login(
        username: username,
        password: password,
      );
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Product> getProduct(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProduct(id);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Coupons> getCoupons() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCoupons();
    } else {
      throw Exception("No internet connection");
    }
  }
  
}
