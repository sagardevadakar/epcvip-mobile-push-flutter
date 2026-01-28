import 'package:flutter/foundation.dart';

class DebugLogger {
  static final List<String> logs = [];

  static void add(String msg) {
    final timestamp = DateTime.now().toIso8601String();
    logs.add("[$timestamp] $msg");
    debugPrint("[DEBUG] $msg");
  }
}
