import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic wrapper widget that checks for app updates on launch.
///
/// Listens to [AppVersionBloc] and calls [onShowUpdateDialog] when
/// an update is available. The calling app provides its own dialog UI.
class UpdateCheckerWrapper extends StatefulWidget {
  final Widget child;

  /// Callback to show the update dialog. Receives the [AppVersionState]
  /// and a [BuildContext]. The app should present its own update dialog.
  final void Function(BuildContext context, AppVersionState state)?
      onShowUpdateDialog;

  const UpdateCheckerWrapper({
    Key? key,
    required this.child,
    this.onShowUpdateDialog,
  }) : super(key: key);

  @override
  State<UpdateCheckerWrapper> createState() => _UpdateCheckerWrapperState();
}

class _UpdateCheckerWrapperState extends State<UpdateCheckerWrapper> {
  @override
  void initState() {
    super.initState();
    // Check for updates when the app launches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppVersionBloc>().add(CheckForUpdateEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppVersionBloc, AppVersionState>(
      listenWhen: (previous, current) {
        // Only show dialog when status changes to updateAvailable
        return current.status == AppVersionStatus.updateAvailable &&
            previous.status != AppVersionStatus.updateAvailable;
      },
      listener: (context, state) {
        if (state.shouldShowUpdateDialog) {
          widget.onShowUpdateDialog?.call(context, state);
        }
      },
      child: widget.child,
    );
  }
}
