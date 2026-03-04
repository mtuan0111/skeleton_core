import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic, reusable alert dialog template with blur backdrop.
///
/// This widget is framework-agnostic and accepts all labels as parameters.
/// Game-specific alert dialogs (e.g. MenuAlert) should wrap this widget
/// and provide game-specific localized labels.
class AlertTemplate extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? possitiveButtonLabel;
  final VoidCallback? onPossitiveButtonPressed;
  final String? negativeButtonLabel;
  final VoidCallback? onNegativeButtonPressed;

  /// Default label for positive button when [possitiveButtonLabel] is null.
  final String defaultPositiveLabel;

  /// Default label for negative button when [negativeButtonLabel] is null.
  final String defaultNegativeLabel;

  const AlertTemplate({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.possitiveButtonLabel,
    this.onPossitiveButtonPressed,
    this.negativeButtonLabel,
    this.onNegativeButtonPressed,
    this.defaultPositiveLabel = 'Yes',
    this.defaultNegativeLabel = 'No',
  });

  Widget _buildPossitiveButton(BuildContext context) {
    return CustomElevatedButton(
      text: possitiveButtonLabel ?? defaultPositiveLabel,
      onPressed: onPossitiveButtonPressed ?? () => Navigator.of(context).pop(),
      color: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).primaryColor,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topLeft,
    );
  }

  Widget _buildNegativeButton(BuildContext context) {
    return CustomElevatedButton(
      text: negativeButtonLabel ?? defaultNegativeLabel,
      onPressed: onNegativeButtonPressed ?? () => Navigator.of(context).pop(),
      color: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                text: title,
                                buttonSize: ButtonSize.small,
                                shapeAt: RoundedWithShapeAt.topLeft,
                                color: Theme.of(context).colorScheme.onPrimary,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).secondaryHeaderColor,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Main dialog content
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shapeAt: RoundedWithShapeAt.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0)
                                    .copyWith(top: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (content != null) content!,
                                    if (message != null)
                                      Text(
                                        message!,
                                        style: AppTextStyles.withColor(
                                            AppTextStyles.bodyLarge(context),
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .getDarker()),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (negativeButtonLabel != null)
                          Expanded(child: _buildNegativeButton(context)),
                        if (negativeButtonLabel != null &&
                            possitiveButtonLabel != null)
                          const SizedBox(width: kSpaceM),
                        if (possitiveButtonLabel != null)
                          Expanded(child: _buildPossitiveButton(context)),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
