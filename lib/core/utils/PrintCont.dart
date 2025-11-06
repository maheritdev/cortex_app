import 'dart:convert';

class PrintCont {
  // Colors for different platforms
  static const _reset = '\x1B[0m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _blue = '\x1B[34m';
  static const _magenta = '\x1B[35m';
  static const _cyan = '\x1B[36m';
  static const _white = '\x1B[37m';
  static const _orange = '\x1B[38;5;208m';
  static const _pink = '\x1B[38;5;205m';
  static const _gray = '\x1B[38;5;245m';

  // Log levels
  static const _levelDebug = '🐛 DEBUG';
  static const _levelInfo = 'ℹ️  INFO';
  static const _levelSuccess = '✅ SUCCESS';
  static const _levelWarning = '⚠️  WARNING';
  static const _levelError = '❌ ERROR';
  static const _levelCritical = '💀 CRITICAL';
  static const _levelNetwork = '🌐 NETWORK';
  static const _levelDatabase = '💾 DATABASE';
  static const _levelBloc = '🔄 BLOC';

  // Enable/disable logs
  static bool _enabled = true;
  static Set<LogLevel> _enabledLevels = LogLevel.values.toSet();

  // Debug mode detection
  static bool get isDebugMode {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }

  // Enable/disable all logs
  static void enable() => _enabled = true;
  static void disable() => _enabled = false;

  // Enable specific log levels
  static void enableLevels(Set<LogLevel> levels) {
    _enabledLevels = levels;
  }

  // Add levels to enabled set
  static void addLevels(Set<LogLevel> levels) {
    _enabledLevels.addAll(levels);
  }

  // Remove levels from enabled set
  static void removeLevels(Set<LogLevel> levels) {
    _enabledLevels.removeAll(levels);
  }

  // Debug log (Blue)
  static void debug(dynamic message, {String? tag, StackTrace? stackTrace}) {
    _log(
      message: message,
      level: LogLevel.debug,
      color: _blue,
      levelText: _levelDebug,
      tag: tag,
      stackTrace: stackTrace,
    );
  }

  // Info log (Cyan)
  static void info(dynamic message, {String? tag}) {
    _log(
      message: message,
      level: LogLevel.info,
      color: _cyan,
      levelText: _levelInfo,
      tag: tag,
    );
  }

  // Success log (Green)
  static void success(dynamic message, {String? tag}) {
    _log(
      message: message,
      level: LogLevel.success,
      color: _green,
      levelText: _levelSuccess,
      tag: tag,
    );
  }

  // Warning log (Yellow)
  static void warning(dynamic message, {String? tag, StackTrace? stackTrace}) {
    _log(
      message: message,
      level: LogLevel.warning,
      color: _yellow,
      levelText: _levelWarning,
      tag: tag,
      stackTrace: stackTrace,
    );
  }

  // Error log (Red)
  static void error(dynamic message, {String? tag, StackTrace? stackTrace}) {
    _log(
      message: message,
      level: LogLevel.error,
      color: _red,
      levelText: _levelError,
      tag: tag,
      stackTrace: stackTrace,
    );
  }

  // Critical error log (Magenta)
  static void critical(dynamic message, {String? tag, StackTrace? stackTrace}) {
    _log(
      message: message,
      level: LogLevel.critical,
      color: _magenta,
      levelText: _levelCritical,
      tag: tag,
      stackTrace: stackTrace,
    );
  }

  // Network log (Orange)
  static void network(dynamic message, {String? tag}) {
    _log(
      message: message,
      level: LogLevel.network,
      color: _orange,
      levelText: _levelNetwork,
      tag: tag,
    );
  }

  // Database log (Pink)
  static void database(dynamic message, {String? tag}) {
    _log(
      message: message,
      level: LogLevel.database,
      color: _pink,
      levelText: _levelDatabase,
      tag: tag,
    );
  }

  // BLoC log (Gray)
  static void bloc(dynamic message, {String? tag}) {
    _log(
      message: message,
      level: LogLevel.bloc,
      color: _gray,
      levelText: _levelBloc,
      tag: tag,
    );
  }

  // Pretty JSON print
  static void json(dynamic jsonData, {String? tag}) {
    if (!_enabled || !_enabledLevels.contains(LogLevel.debug)) return;

    try {
      final prettyString = _formatJson(jsonData);
      _printColored(
        '$prettyString',
        color: _cyan,
        level: _levelDebug,
        tag: tag ?? 'JSON',
      );
    } catch (e) {
      _printColored(
        'Invalid JSON: $jsonData',
        color: _red,
        level: _levelError,
        tag: tag ?? 'JSON',
      );
    }
  }

  // Divider for better readability
  static void divider({String title = '', int length = 50}) {
    if (!_enabled) return;

    final dividerLine = '─' * length;
    if (title.isEmpty) {
      print('$dividerLine');
    } else {
      final titleLine = '─' * 2;
      print('$titleLine $title $titleLine');
    }
  }

  // Section header
  static void header(String title, {LogLevel level = LogLevel.info}) {
    if (!_enabled || !_enabledLevels.contains(level)) return;

    final color = _getColorForLevel(level);
    final header = '┌${'─' * (title.length + 2)}┐';
    final middle = '│ $title │';
    final footer = '└${'─' * (title.length + 2)}┘';

    print('$color$header$_reset');
    print('$color$middle$_reset');
    print('$color$footer$_reset');
  }

  // Performance tracking
  static T trackTime<T>(String operation, T Function() function, {String? tag}) {
    final stopwatch = Stopwatch()..start();
    final result = function();
    stopwatch.stop();

    _log(
      message: '$operation completed in ${stopwatch.elapsedMilliseconds}ms',
      level: LogLevel.debug,
      color: _blue,
      levelText: '⏱️  PERFORMANCE',
      tag: tag,
    );

    return result;
  }

  // Stack trace helper
  static void stackTrace(StackTrace stackTrace, {String? tag}) {
    if (!_enabled || !_enabledLevels.contains(LogLevel.error)) return;

    _printColored(
      'Stack Trace:\n$stackTrace',
      color: _red,
      level: _levelError,
      tag: tag ?? 'STACK',
    );
  }

  // Private log method
  static void _log({
    required dynamic message,
    required LogLevel level,
    required String color,
    required String levelText,
    String? tag,
    StackTrace? stackTrace,
  }) {
    if (!_enabled || !_enabledLevels.contains(level) || !isDebugMode) return;

    _printColored(
      message.toString(),
      color: color,
      level: levelText,
      tag: tag,
    );

    if (stackTrace != null && level.index >= LogLevel.warning.index) {
      _printColored(
        'Stack Trace:\n$stackTrace',
        color: color,
        level: levelText,
        tag: tag != null ? '$tag-STACK' : 'STACK',
      );
    }
  }

  // Colored print method
  static void _printColored(
      String message, {
        required String color,
        required String level,
        String? tag,
      }) {
    final timestamp = _getTimestamp();
    final tagText = tag != null ? '[$tag]' : '';

    final lines = message.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final prefix = i == 0 ? '$level$tagText $timestamp: ' : '${' ' * (level.length + tagText.length + 12)}';
      print('$color$prefix$line$_reset');
    }
  }

  // Get formatted timestamp
  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
  }

  // Format JSON for pretty printing
  static String _formatJson(dynamic jsonData) {
    const encoder = JsonEncoder.withIndent('  ');
    if (jsonData is String) {
      final decoded = jsonDecode(jsonData);
      return encoder.convert(decoded);
    } else {
      return encoder.convert(jsonData);
    }
  }

  // Get color for log level
  static String _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _blue;
      case LogLevel.info:
        return _cyan;
      case LogLevel.success:
        return _green;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
      case LogLevel.critical:
        return _magenta;
      case LogLevel.network:
        return _orange;
      case LogLevel.database:
        return _pink;
      case LogLevel.bloc:
        return _gray;
    }
  }
}

// Log level enum
enum LogLevel {
  debug,
  info,
  success,
  warning,
  error,
  critical,
  network,
  database,
  bloc,
}

// Extension for easy logging on objects
extension PrintContExtension on Object {
  void logDebug({String? tag}) => PrintCont.debug(this, tag: tag);
  void logInfo({String? tag}) => PrintCont.info(this, tag: tag);
  void logSuccess({String? tag}) => PrintCont.success(this, tag: tag);
  void logWarning({String? tag}) => PrintCont.warning(this, tag: tag);
  void logError({String? tag, StackTrace? stackTrace}) =>
      PrintCont.error(this, tag: tag, stackTrace: stackTrace);
  void logCritical({String? tag, StackTrace? stackTrace}) =>
      PrintCont.critical(this, tag: tag, stackTrace: stackTrace);
  void logNetwork({String? tag}) => PrintCont.network(this, tag: tag);
  void logDatabase({String? tag}) => PrintCont.database(this, tag: tag);
  void logBloc({String? tag}) => PrintCont.bloc(this, tag: tag);
  void logJson({String? tag}) => PrintCont.json(this, tag: tag);
}