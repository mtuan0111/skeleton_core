import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

mixin AppVersionStateMixin<T extends StatefulWidget> on State<T> {
  String? appVersion;
  String? appBuildNumber;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if (mounted) {
        setState(() {
          appVersion = packageInfo.version;
          appBuildNumber = packageInfo.buildNumber;
        });
      }
    });
  }
}
