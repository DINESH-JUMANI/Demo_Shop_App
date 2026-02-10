import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Log levels for filtering log messages
enum LogLevel { debug, info, warning, error, critical }

/// Custom AppLogger using native Dart logging
class AppLogger {
  AppLogger._(); // Private constructor

  static bool _isEnabled = true;
  static LogLevel _minimumLevel = LogLevel.debug;

  /// Enable/disable logging
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Set minimum log level
  static void setLogLevel(LogLevel level) {
    _minimumLevel = level;
  }

  /// Check if a log level should be printed
  static bool _shouldLog(LogLevel level) {
    return _isEnabled && level.index >= _minimumLevel.index;
  }

  /// Format log message with timestamp and level
  static String _formatMessage(
    LogLevel level,
    String message, [
    dynamic error,
  ]) {
    final timestamp = DateTime.now().toIso8601String();
    final emoji = _getEmoji(level);
    final levelName = level.name.toUpperCase();

    final buffer = StringBuffer();
    buffer.write('$emoji [$levelName] $timestamp - $message');

    if (error != null) {
      buffer.write('\n  Error: $error');
    }

    return buffer.toString();
  }

  /// Get emoji for log level
  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.critical:
        return '💥';
    }
  }

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_shouldLog(LogLevel.debug)) return;

    final formattedMessage = _formatMessage(LogLevel.debug, message, error);
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 500, // Debug level
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_shouldLog(LogLevel.info)) return;

    final formattedMessage = _formatMessage(LogLevel.info, message, error);
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 800, // Info level
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }
  }

  /// Log success message (alias for info with success emoji)
  static void success(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_shouldLog(LogLevel.info)) return;

    final timestamp = DateTime.now().toIso8601String();
    final formattedMessage = '[SUCCESS] $timestamp - $message';
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 800, // Info level
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_shouldLog(LogLevel.warning)) return;

    final formattedMessage = _formatMessage(LogLevel.warning, message, error);
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 900, // Warning level
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_shouldLog(LogLevel.error)) return;

    final formattedMessage = _formatMessage(LogLevel.error, message, error);
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );

    // Always print errors in debug mode
    if (kDebugMode) {
      debugPrint(formattedMessage);
      if (stackTrace != null) {
        debugPrint('Stack Trace:\n$stackTrace');
      }
    }
  }

  /// Log critical message
  static void critical(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (!_shouldLog(LogLevel.critical)) return;

    final formattedMessage = _formatMessage(LogLevel.critical, message, error);
    dev.log(
      formattedMessage,
      name: 'AppLogger',
      level: 1200,
      error: error,
      stackTrace: stackTrace,
    );

    // Always print critical errors
    debugPrint(formattedMessage);
    if (stackTrace != null) {
      debugPrint('Stack Trace:\n$stackTrace');
    }
  }

  // Specialized logging methods for different app scenarios

  /// Log network requests
  static void networkRequest(
    String url,
    String method, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    final requestInfo = {
      'url': url,
      'method': method,
      'headers': headers,
      'body': body,
    };
    debug('Network Request', requestInfo);
  }

  /// Log network responses
  static void networkResponse(
    String url,
    int statusCode, {
    dynamic data,
    Duration? duration,
  }) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final responseInfo = {
      'url': url,
      'statusCode': statusCode,
      'data': data,
      'duration_ms': duration?.inMilliseconds,
    };

    if (isSuccess) {
      debug('Network Success', responseInfo);
    } else {
      warning('Network Error', responseInfo);
    }
  }

  /// Log theme changes
  static void themeChange(String from, String to) {
    info('Theme Changed: $from → $to');
  }

  /// Log user actions
  static void userAction(String action, {Map<String, dynamic>? metadata}) {
    final actionInfo = {
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      ...?metadata,
    };
    info('User Action', actionInfo);
  }

  /// Log navigation events
  static void navigation(String from, String to) {
    debug('Navigation: $from → $to');
  }

  /// Log performance metrics
  static void performance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metadata,
  }) {
    final isSlowOperation = duration.inMilliseconds > 1000;
    final performanceInfo = {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      ...?metadata,
    };

    if (isSlowOperation) {
      warning('Slow Performance', performanceInfo);
    } else {
      debug('Performance', performanceInfo);
    }
  }

  /// Log app lifecycle events
  static void appLifecycle(String event) {
    info('App Lifecycle: $event');
  }
}

/// Extension for convenient logging from any object
extension LoggingExtension on Object {
  /// Log debug message with object context
  void logDebug([String? message]) {
    if (kDebugMode) {
      AppLogger.debug('$runtimeType: ${message ?? toString()}');
    }
  }

  /// Log info message with object context
  void logInfo([String? message]) {
    if (kDebugMode) {
      AppLogger.info('$runtimeType: ${message ?? toString()}');
    }
  }

  /// Log error message with object context
  void logError([String? message, dynamic error, StackTrace? stackTrace]) {
    AppLogger.error(
      '$runtimeType: ${message ?? toString()}',
      error,
      stackTrace,
    );
  }
}

/// Logger utility methods
class LoggerUtils {
  /// Initialize logger with app start
  static void initialize() {
    AppLogger.info('App Logger Initialized');
  }

  /// Log app lifecycle events
  static void logAppStart() {
    AppLogger.appLifecycle('App Started');
  }

  static void logAppPause() {
    AppLogger.appLifecycle('App Paused');
  }

  static void logAppResume() {
    AppLogger.appLifecycle('App Resumed');
  }

  static void logAppDetached() {
    AppLogger.appLifecycle('App Detached');
  }

  /// Set logging configuration for different build modes
  static void configureForEnvironment() {
    if (kReleaseMode) {
      // In release mode, only log errors and critical messages
      AppLogger.setLogLevel(LogLevel.error);
    } else if (kProfileMode) {
      // In profile mode, log warnings and above
      AppLogger.setLogLevel(LogLevel.warning);
    } else {
      // In debug mode, log everything
      AppLogger.setLogLevel(LogLevel.debug);
    }
  }

  /// Log app termination
  static void logAppTerminate() {
    AppLogger.appLifecycle('App Terminated');
  }

  /// Log memory usage check
  static void logMemoryUsage() {
    AppLogger.info('Memory Usage Check');
  }

  /// Log device information
  static void logDeviceInfo(Map<String, dynamic> deviceInfo) {
    AppLogger.info('Device Info', deviceInfo);
  }

  /// Log feature usage
  static void logFeatureUsage(
    String feature, {
    Map<String, dynamic>? metadata,
  }) {
    AppLogger.userAction('Feature Used: $feature', metadata: metadata);
  }

  /// Log errors with context
  static void logErrorWithContext(
    String operation,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    AppLogger.error('Error in $operation', error, stackTrace);
  }
}
