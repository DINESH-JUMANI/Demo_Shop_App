// App Routes

import 'package:demo_shop_app/core/widgets/home_navigation_screen.dart';
import 'package:demo_shop_app/features/products/screens/product_detail_screen.dart';
import 'package:demo_shop_app/features/splash/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String home = '/home';
  static const String productDetail = '/product-detail';

  // Routes Map
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    home: (context) => const BottomNavBar(),
  };

  // On Generate Route for dynamic routing
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetail:
        final productId = settings.arguments as int?;
        if (productId != null) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
            settings: settings,
          );
        }
        return null;
      default:
        return null;
    }
  }
}
