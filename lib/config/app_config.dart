/// Environment configuration for the E-Commerce Application.
/// Retrieves the environment-specific API URL passed via build parameter:
/// `--dart-define=API_URL=...`
class AppConfig {
  /// Base API URL retrieved from `--dart-define=API_URL=...`
  /// Example values:
  /// - dev: https://dev-api.example.com
  /// - staging: https://staging-api.example.com
  /// - prod: https://api.example.com
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.example.com',
  );

  /// Utility getter to identify the active environment name
  static String get environmentName {
    if (apiUrl.contains('dev-api')) return 'dev';
    if (apiUrl.contains('staging-api')) return 'staging';
    return 'prod';
  }
}
