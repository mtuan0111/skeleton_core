/// Skeleton Core — A reusable Flutter game-shell package.
///
/// Provides common screens, models, blocs, services, and helpers
/// that can be shared across multiple game projects.
library skeleton_core;

// Config
export 'src/config/env_config.dart';
export 'src/config/theme_config.dart';

// Models
export 'src/models/user_model.dart';
export 'src/models/base_setting_model.dart';
export 'src/models/app_version_model.dart';

// Helpers
export 'src/helpers/preferences_key.dart';
export 'src/helpers/ui_constants.dart';
export 'src/helpers/extension.dart';
export 'src/helpers/const.dart';
export 'src/helpers/app_text_styles.dart';
export 'src/helpers/helper.dart';
export 'src/helpers/core_lang.dart';

// Localization
export 'src/localization/core_localizations.dart';

// Widgets
export 'src/widgets/template_widgets.dart';
// alert_template.dart and update_notice_dialog.dart are available
// for direct import but not auto-exported to avoid conflicts with
// app-specific localized versions.

// Animations
export 'src/animations/particle.dart';
export 'src/animations/particle_system.dart';
export 'src/animations/animated_game_wrapper.dart';
export 'src/animations/game_animation_triggers.dart';
export 'src/animations/screen_shake_controller.dart';
export 'src/animations/animation_constants.dart';

// Blocs — User
export 'src/blocs/user/user_bloc.dart';
export 'src/blocs/user/user_event.dart';
export 'src/blocs/user/user_state.dart';

// Blocs — Setting
export 'src/blocs/setting/setting_bloc.dart';
export 'src/blocs/setting/setting_event.dart';
export 'src/blocs/setting/setting_state.dart';

// Blocs — Audio
export 'src/blocs/audio/audio_bloc.dart';
export 'src/blocs/audio/audio_event.dart';
export 'src/blocs/audio/audio_state.dart';

// Blocs — Vibration
export 'src/blocs/vibration/vibration_bloc.dart';
export 'src/blocs/vibration/vibration_event.dart';
export 'src/blocs/vibration/vibration_state.dart';

// Blocs — App Version
export 'src/blocs/app_version/app_version_bloc.dart';
export 'src/blocs/app_version/app_version_event.dart';
export 'src/blocs/app_version/app_version_state.dart';

// Blocs — Menu
export 'src/blocs/menu/menu_bloc.dart';

// Blocs — Tour
export 'src/blocs/tour/tour_bloc.dart';
export 'src/blocs/tour/tour_event.dart';
export 'src/blocs/tour/tour_state.dart';

// Widgets
export 'src/widgets/loading_widget.dart';
export 'src/widgets/update_checker_wrapper.dart';

// Services
export 'src/services/audio_services.dart';
export 'src/services/user_services.dart';
export 'src/services/setting_services.dart';
export 'src/services/auth_services.dart';
export 'src/services/app_version_services.dart';
