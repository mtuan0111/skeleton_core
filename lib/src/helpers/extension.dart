import 'package:flutter/material.dart';

extension ColorCustome on Color {
  Color getDarker({int percentage = 50}) {
    int r = (((this.r * 255.0).round() & 0xff) * (100 - percentage) / 100)
        .round();
    int g = (((this.g * 255.0).round() & 0xff) * (100 - percentage) / 100)
        .round();
    int b = (((this.b * 255.0).round() & 0xff) * (100 - percentage) / 100)
        .round();
    int a = (this.a * 255.0).round() & 0xff;
    return Color.fromARGB(a, r, g, b);
  }

  Color getLighter({int percentage = 50}) {
    int r =
        (((this.r * 255.0).round() & 0xff) +
                ((255 - ((this.r * 255.0).round() & 0xff)) * percentage / 100))
            .round();
    int g =
        (((this.g * 255.0).round() & 0xff) +
                ((255 - ((this.g * 255.0).round() & 0xff)) * percentage / 100))
            .round();
    int b =
        (((this.b * 255.0).round() & 0xff) +
                ((255 - ((this.b * 255.0).round() & 0xff)) * percentage / 100))
            .round();
    int a = (this.a * 255.0).round() & 0xff;
    return Color.fromARGB(a, r, g, b);
  }

  Color getTheOpposite({double percent = 30}) {
    int r = 255 - (((this.r * 255.0).round() & 0xff) * percent / 100).round();
    int g = 255 - (((this.g * 255.0).round() & 0xff) * percent / 100).round();
    int b = 255 - (((this.b * 255.0).round() & 0xff) * percent / 100).round();
    int a = (this.a * 255.0).round() & 0xff;
    return Color.fromARGB(a, r, g, b);
  }

  /// Returns a smart contrasting color based on the luminance of this color.
  Color getSmartColor(BuildContext context) {
    final luminance = computeLuminance();
    final theme = Theme.of(context);
    return luminance > 0.5
        ? theme.colorScheme.onSurface
        : theme.scaffoldBackgroundColor;
  }
}

extension LinearGradientCustom on LinearGradient {
  getDarker({int percentage = 50}) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors
          .map((color) => color.getDarker(percentage: percentage))
          .toList(),
      stops: stops,
      tileMode: tileMode,
      transform: transform,
    );
  }
}

extension StringExtensions on String {
  String snakeCaseToCamel() {
    if (isEmpty) return this;

    List<String> parts = split('_');
    String camelCaseString = parts[0];

    for (int i = 1; i < parts.length; i++) {
      String part = parts[i];
      if (part.isNotEmpty) {
        camelCaseString +=
            part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
    }

    return camelCaseString;
  }
}
