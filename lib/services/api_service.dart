import 'package:ecommerecstore/config/app_config.dart';

/// Central API service providing base URL configuration for network requests.
class ApiService {
  /// Base API URL derived from `--dart-define=API_URL=...`
  static String get baseUrl => AppConfig.apiUrl;
}
