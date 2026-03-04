import 'package:flutter/material.dart';

/// A simple centered loading indicator widget.
/// Used as a placeholder while content is loading.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
