/// Skeleton Core — A reusable Flutter game-shell package.
///
/// Provides common screens, models, blocs, services, and helpers
/// that can be shared across multiple game projects.
library skeleton_core;

// Config
export 'src/config/env_config.dart';

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

// Services
export 'src/services/audio_services.dart';
export 'src/services/user_services.dart';
export 'src/services/setting_services.dart';
export 'src/services/auth_services.dart';
export 'src/services/app_version_services.dart';
