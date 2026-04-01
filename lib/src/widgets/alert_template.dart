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

  // New properties for better customization
  final Color? backgroundColor;
  final Color? titleBackgroundColor;
  final LinearGradient? titleGradient;
  final TextStyle? messageStyle;
  final Widget Function(BuildContext context, Widget child)? bodyWrapper;
  final RoundedWithShapeAt? titleShapeAt;
  final double? titleRadius;

  const AlertTemplate({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.possitiveButtonLabel,
    this.onPossitiveButtonPressed,
    this.negativeButtonLabel,
    this.onNegativeButtonPressed,
    this.backgroundColor,
    this.titleBackgroundColor,
    this.titleGradient,
    this.messageStyle,
    this.bodyWrapper,
    this.titleShapeAt = RoundedWithShapeAt.topLeft,
    this.titleRadius,
  });

  Widget _buildPossitiveButton(BuildContext context) {
    return CustomElevatedButton(
      text: possitiveButtonLabel ?? coreLang(context).yes,
      onPressed: onPossitiveButtonPressed ?? () => Navigator.of(context).pop(),
      color: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).primaryColor,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topLeft,
    );
  }

  Widget _buildNegativeButton(BuildContext context) {
    return CustomElevatedButton(
      text: negativeButtonLabel ?? coreLang(context).no,
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
                                  shapeAt: titleShapeAt,
                                  buttonRadius: titleRadius,
                                  color: titleBackgroundColor != null
                                      ? titleBackgroundColor!.getSmartColor(context)
                                      : Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor: titleBackgroundColor,
                                  gradient: titleGradient ??
                                      (titleBackgroundColor == null
                                          ? LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Theme.of(context).primaryColor,
                                                Theme.of(context)
                                                    .secondaryHeaderColor,
                                              ],
                                            )
                                          : null),
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
                            child: bodyWrapper != null
                                ? bodyWrapper!(context, _buildBodyContent(context))
                                : CustomElevatedButton(
                                    backgroundColor: backgroundColor ??
                                        Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    shapeAt: RoundedWithShapeAt.topRight,
                                    child: _buildBodyContent(context),
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

  Widget _buildBodyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content != null) content!,
          if (message != null)
            Text(
              message!,
              style: messageStyle ??
                  AppTextStyles.withColor(AppTextStyles.bodyLarge(context),
                      Theme.of(context).colorScheme.primary.getDarker()),
            ),
        ],
      ),
    );
  }
}
