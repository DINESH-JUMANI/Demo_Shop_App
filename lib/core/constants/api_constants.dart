// lib/core/constants/api_constants.dart

class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://dummyjson.com';

  // API Endpoints
  static const String productsEndpoint = '/products';
  static const String productSearchEndpoint = '/products/search';
  static String productByIdEndpoint(int id) => '/products/$id';
  static String productsByCategoryEndpoint(String category) =>
      '/products/category/$category';

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
}
