import 'dart:math';

// Function taken from AppWrite flutter-sdk
// https://github.com/appwrite/sdk-for-flutter/blob/main/lib/id.dart
class ID {
  ID._();

  // Generate a unique ID based on timestamp
  // Recreated from https://www.php.net/manual/en/function.uniqid.php
  static String _uniqid() {
    final now = DateTime.now();
    final secondsSinceEpoch = (now.millisecondsSinceEpoch / 1000).floor();
    final msecs = now.microsecondsSinceEpoch - secondsSinceEpoch * 1000000;
    return secondsSinceEpoch.toRadixString(16) +
        msecs.toRadixString(16).padLeft(5, '0');
  }

  // Generate a unique ID with padding to have a longer ID
  // Recreated from https://github.com/utopia-php/database/blob/main/src/Database/ID.php#L13
  static String _unique({int padding = 7}) {
    var id = _uniqid();

    if (padding > 0) {
      final sb = StringBuffer();
      for (var i = 0; i < padding; i++) {
        sb.write(Random().nextInt(16).toRadixString(16));
      }

      id += sb.toString();
    }

    return id;
  }

  static String unique() {
    return _unique();
  }
}
