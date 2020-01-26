import 'constants.dart';

/// Server config
const serverConfig = {
    "type": "woo",
    "url": "https://tashkentsupermarket.com/",
    "consumerKey": "ck_347d24c7cb85c4a9965481d780f6d49bc4f40fa0",
    "consumerSecret": "cs_bdaed9e1e31e3cbeb7777b266fca2dc6f07e5b67",
    "blog": "https://tashkentsupermarket.com/blog",
    "forgetPassword": "https://tashkentsupermarket.com/wp-login.php?action=lostpassword"
};

const CategoriesListLayout = kCategoriesLayout.card;

const Payments = {
  "paypal": "assets/icons/payment/paypal.png",
  "stripe": "assets/icons/payment/stripe.png",
  "razorpay": "assets/icons/payment/razorpay.png",
  "cardknox": "assets/icons/payment/cardknox.png",
};


/// The product variant config
const ProductVariantLayout = {
    "color": "color",
    "size": "box",
    "height": "option",
};

const kAdvanceConfig = {
    "DefaultCurrency": {"symbol": "\$", "decimalDigits": 2},
    "IsRequiredLogin": false,
    "GuestCheckout": true,
    "EnableShipping": true,
    "GridCount": 3,
    "DetailedBlogLayout": kBlogLayout.halfSizeImageType
};

/// The Google API Key to support Pick up the Address automatically
/// We recommend to generate both ios and android to restrict by bundle app id
/// The download package is remove these keys, please use your own key
const kGoogleAPIKey = {
    "android": "AIzaSyBL_7TOT6NlM0lgLO6lpSnB6OMM31_h32Q",
    "ios": "AIzaSyBL_7TOT6NlM0lgLO6lpSnB6OMM31_h32Q"
};

/// use to config the product image height for the product detail
/// height=(percent * width-screen)
/// isHero: support hero animate
const kProductDetail = {
    "height": 0.5,
    "marginTop": 60,
    "isHero": false,
    "safeArea": false,
    "showVideo": true,
    "showThumbnailAtLeast": 3
};

const String adminEmail = "admin@tashkentsupermarket.com";
