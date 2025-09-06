extension StringExtension on String? {
  bool get isValidIP {
    final ipRegex = RegExp(r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return this != null && ipRegex.hasMatch(this!) && this!.isNotEmpty;
  }

  bool get isValidPort {
    return this != null && this!.length == 4 && this!.isNotEmpty;
  }

  bool get isValidPassword {
    return this != null && this!.length >= 4 && this!.isNotEmpty;
  }
}
