---
trigger: always_on
---

# 🚀 Flutter BLoC Architecture Guidelines

## 🔴 **CRITICAL RULES - MUST FOLLOW**

This app extends **skeleton_core** BLoC architecture. All projects following this pattern must adhere to these rules:

### 1. **PURE BLoCs - NO UI LOGIC**
- ❌ **NO BuildContext in BLoCs** — Never pass context to events/constructors
- ❌ **NO Navigation calls** — No `Navigator.push()`, `Utils.popNav()`
- ❌ **NO Toasts/Dialogs** — No `Fluttertoast.showToast()`, `showDialog()`
- ✅ **BLoCs emit pure state data only**
- ✅ **UI handles all interactions via BlocListener/BlocBuilder**

### 2. **Event-Driven Communication**
BLoCs communicate through events, not direct method calls:

```dart
// ✅ CORRECT: Event-driven
_audioBloc.add(PlayTapAudio());
_vibrationBloc.add(VibrateShort());

// ❌ WRONG: Direct method calls
_audioService.playTap();
```

### 3. **State Pattern**
All states are immutable with `copyWith` methods:

```dart
class ExampleState {
  final int score;
  final bool isLoading;

  const ExampleState({this.score = 0, this.isLoading = false});

  ExampleState copyWith({int? score, bool? isLoading}) => ExampleState(
    score: score ?? this.score,
    isLoading: isLoading ?? this.isLoading,
  );
}
```

### 4. **Pure Events**
All events carry only data — never UI objects:

```dart
// ✅ CORRECT
class UpdateProfile extends UserEvent {
  final String displayName;
  UpdateProfile(this.displayName);
}

// ❌ WRONG
class UpdateProfile extends UserEvent {
  final BuildContext context; // ❌ NEVER!
  final String displayName;
}
```

### 5. **UI Must Not Call Services Directly**
The UI layer must **never** call service classes directly. All service interactions must go through BLoCs via events:

```dart
// ✅ CORRECT: UI dispatches event → BLoC calls service
context.read<GameBloc>().add(SaveGameRequested());

// In BLoC:
void _onSaveGameRequested(SaveGameRequested event, Emitter<GameState> emitter) {
  GameStateStorage.saveState(state);
  emitter(state.copyWith(isSaved: true));
}

// ❌ WRONG: UI calls service directly
GameStateStorage.saveState(currentState);
AdService.showInterstitialAd();
FirebaseAnalytics.instance.logEvent(name: 'game_over');
```

**Why?** Services are implementation details. The BLoC is the single source of truth for when and how services are invoked. This ensures:
- Testability — BLoCs can be tested with mock services
- Consistency — all side effects are tracked through BLoC state
- Maintainability — changing a service only requires updating the BLoC, not every UI file

---

## 📁 **BLoC Architecture**

The app follows strict BLoC patterns with proper separation of concerns:

```
📁 lib/blocs/
├── 📁 objects/        # Business Logic BLoCs
│   ├── 📁 game/       # Core game/app logic
│   ├── 📁 audio/      # Audio management (from skeleton_core)
│   ├── 📁 vibration/  # Haptic feedback (from skeleton_core)
│   ├── 📁 setting/    # App settings (from skeleton_core)
│   └── 📁 user/       # User management (from skeleton_core)
└── 📁 navs/           # Navigation BLoCs
    ├── 📁 menu/       # Main menu navigation
    └── 📁 player/     # Screen-specific navigation
```

---

## 🎯 **Implementation Patterns**

### 1. **Action Flags for UI Side Effects**
Use boolean flags in state to trigger one-shot UI actions:

```dart
class GameState {
  final bool shouldShowWelcome;

  GameState copyWith({bool? shouldShowWelcome}) => GameState(
    shouldShowWelcome: shouldShowWelcome ?? this.shouldShowWelcome,
  );
}

// In BLoC:
emitter(state.copyWith(shouldShowWelcome: true));

// In UI — BlocListener detects the flag, performs UI action, then clears it:
BlocListener<GameBloc, GameState>(
  listenWhen: (prev, curr) => !prev.shouldShowWelcome && curr.shouldShowWelcome,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    context.read<GameBloc>().add(ClearWelcomeFlag());
  },
)
```

### 2. **Dependency Injection for BLoC Communication**
Inject dependent BLoCs via constructor:

```dart
class GameBloc extends Bloc<GameEvent, GameState> {
  final AudioBloc? audioBloc;
  final VibrationBloc? vibrationBloc;

  GameBloc({this.audioBloc, this.vibrationBloc}) : super(const GameState()) {
    on<ScoreUpdated>(_onScoreUpdated);
  }

  void _onScoreUpdated(ScoreUpdated event, Emitter<GameState> emitter) {
    emitter(state.copyWith(score: event.score));
    audioBloc?.add(PlayTapAudio());
  }
}
```

### 3. **Navigation via Cubits**
Manage screen navigation with dedicated cubits:

```dart
class PlayerNavCubit extends Cubit<PlayerNavState> {
  PlayerNavCubit() : super(const SetDifficultyState());

  void showPlay() => emit(const PlayingState());
  void showGameOver() => emit(const GameOverState());
}

// UI layer handles the actual navigation:
BlocBuilder<PlayerNavCubit, PlayerNavState>(
  builder: (context, state) {
    return Navigator(pages: [
      if (state is PlayingState) const MaterialPage(child: PlayScreen()),
      if (state is GameOverState) const MaterialPage(child: GameOverScreen()),
    ]);
  },
)
```

### 4. **State Persistence with Services**
Keep persistence logic in dedicated service classes, called from BLoC handlers:

```dart
// Service (pure Dart, no UI)
class GameStateStorage {
  static Future<void> saveState(GameState state) async { ... }
  static Future<GameState?> loadState() async { ... }
  static Future<void> clearState() async { ... }
}

// BLoC calls the service
void _onMoveCompleted(MoveCompleted event, Emitter<GameState> emitter) {
  final newState = state.copyWith(moves: state.moves + 1);
  emitter(newState);
  GameStateStorage.saveState(newState); // Fire-and-forget
}
```

### 5. **State Serialization**
When persisting state, add `toJson()` / `fromJson()` to the state class:

```dart
class GameState {
  Map<String, dynamic> toJson() => { 'score': score, 'level': level };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    score: json['score'] as int,
    level: json['level'] as int,
  );
}
```

---

## 🚨 **Summary Rules**

1. **NO BuildContext anywhere in BLoCs, events, or states**
2. **BLoCs emit pure state data only** — UI reads state & reacts
3. **Use `BlocListener` for one-shot side effects** (toasts, navigation, dialogs)
4. **Use `BlocBuilder` for rebuilding UI** based on state changes
5. **Use action flags** (`shouldShowX: bool`) for triggering UI actions from BLoCs
6. **Communication between BLoCs** is via events + dependency injection
7. **Persistence logic** lives in service classes, not in BLoCs directly
8. **All states are immutable** with `copyWith` methods
9. **Navigation** is managed by dedicated Cubits, not direct `Navigator` calls
10. **Localization** is a UI-layer concern — BLoCs emit keys, UI translates
11. **UI must NOT call services directly** — all service calls go through BLoCs via events