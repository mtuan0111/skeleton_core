import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:skeleton_core/src/widgets/alert_template.dart';
import 'package:url_launcher/url_launcher.dart';

/// A generic update notice dialog that works with AppVersionModel from skeleton_core.
///
/// All user-facing strings must be provided via the [labels] parameter.
class UpdateNoticeDialog extends StatelessWidget {
  final AppVersionModel versionInfo;
  final String currentVersion;
  final bool isForceUpdate;
  final VoidCallback? onUpdateLater;
  final VoidCallback? onDismiss;
  final UpdateNoticeLabels labels;

  const UpdateNoticeDialog({
    Key? key,
    required this.versionInfo,
    required this.currentVersion,
    required this.isForceUpdate,
    this.onUpdateLater,
    this.onDismiss,
    required this.labels,
  }) : super(key: key);

  String get _storeUrl {
    if (Platform.isAndroid) {
      final packageName =
          dotenv.env['ANDROID_PACKAGE_NAME'] ?? 'com.example.app';
      return 'https://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      final appId = dotenv.env['IOS_APP_ID'] ?? '1234567890';
      return 'https://apps.apple.com/app/id$appId';
    }
    return '';
  }

  Future<void> _launchStore() async {
    final uri = Uri.parse(_storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final localizedMessage = versionInfo.getLocalizedReleaseMessage(locale);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: AlertTemplate(
        title: isForceUpdate ? labels.updateRequired : labels.updateAvailable,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                labels.currentVersion,
                currentVersion,
              ),
              const SizedBox(height: kSpaceSM),
              _buildInfoRow(
                context,
                labels.newVersion,
                versionInfo.versionName,
              ),
              if (localizedMessage != null) ...[
                const SizedBox(height: kSpaceL),
                Text(
                  labels.whatsNew,
                  style: AppTextStyles.bodyLargeBoldOnDialogBackground(context),
                ),
                const SizedBox(height: kSpaceSM),
                Text(
                  localizedMessage,
                  style: AppTextStyles.bodyLargeOnDialogBackground(context),
                ),
              ],
              if (isForceUpdate) ...[
                const SizedBox(height: kSpaceL),
                CustomElevatedButton(
                  backgroundColor: Colors.orangeAccent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: Text(
                          labels.forceUpdateMessage,
                          style: AppTextStyles.withColor(
                              AppTextStyles.bodyLarge(context),
                              Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        possitiveButtonLabel: isForceUpdate ? labels.updateNow : labels.update,
        onPossitiveButtonPressed: () {
          _launchStore();
        },
        negativeButtonLabel: !isForceUpdate ? labels.later : null,
        onNegativeButtonPressed: !isForceUpdate
            ? () {
                Navigator.of(context).pop();
                onUpdateLater?.call();
              }
            : null,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLargeBoldOnDialogBackground(context),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLargeOnDialogBackground(context),
        ),
      ],
    );
  }
}

/// Labels for the UpdateNoticeDialog.
/// All strings are required so the dialog is fully localized.
class UpdateNoticeLabels {
  final String updateRequired;
  final String updateAvailable;
  final String currentVersion;
  final String newVersion;
  final String whatsNew;
  final String forceUpdateMessage;
  final String updateNow;
  final String update;
  final String later;

  const UpdateNoticeLabels({
    required this.updateRequired,
    required this.updateAvailable,
    required this.currentVersion,
    required this.newVersion,
    required this.whatsNew,
    required this.forceUpdateMessage,
    required this.updateNow,
    required this.update,
    required this.later,
  });
}
