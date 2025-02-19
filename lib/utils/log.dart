enum LogLevel { info, warning, error }

void log(LogLevel logLevel, String text) {
  DateTime now = DateTime.now();
  String textFormatted = "${now.hour}:${now.minute}  -> ";
  String textColorized = _getColorizedText(logLevel, textFormatted, text);
  print(textColorized);
}

String _getColorizedText(LogLevel logLevel, String formattedText, String text) {
  const logLevelColors = {
    LogLevel.info: '\x1B[32m',
    LogLevel.warning: '\x1B[33m',
    LogLevel.error: '\x1B[31m',
  };
  String colorCode = logLevelColors[logLevel] ?? '';
  return '$colorCode$formattedText$text\x1B[0m';
}
