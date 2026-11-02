/// Central place for API configuration (taken from the Mock API V2 docs).
class ApiConfig {
  static const String baseUrl = 'https://mock-api.calleyacd.com/api';

  /// Sample credentials from the Postman documentation.
  static const String userId = '68626f9497757cb741f449b0';
  static const String email = 'dhrubo@yopmail.com';

  static const Duration timeout = Duration(seconds: 20);
}
