import 'dart:convert';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String btoa() {
    List<int> bytes = utf8.encode(this);

    return base64.encode(bytes);
  }
}
