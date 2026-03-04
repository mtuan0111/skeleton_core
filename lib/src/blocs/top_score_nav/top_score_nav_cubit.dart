import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// TopScore Navigation State
// ============================================================================

/// Base state for top score navigation.
abstract class TopScoreNavState {}

/// Root state — shows the top score list.
class TopScoreRootState extends TopScoreNavState {}

/// Detail state — shows a specific score entry's details.
///
/// Uses generic types so apps can provide their own record model
/// and ranking period enum.
class TopScoreDetailState<TRecord, TPeriod> extends TopScoreNavState {
  final TRecord record;
  final int? ranking;
  final TPeriod period;
  final bool isPersonalView;

  TopScoreDetailState({
    required this.record,
    required this.ranking,
    required this.period,
    required this.isPersonalView,
  });
}

// ============================================================================
// TopScore Navigation Cubit
// ============================================================================

/// A generic cubit for navigating between top score screens.
///
/// Type parameters:
/// - [TRecord]: The model type for a recorded score entry.
/// - [TPeriod]: The enum/type for ranking period (e.g. daily, weekly, all).
class TopScoreNavCubit<TRecord, TPeriod> extends Cubit<TopScoreNavState> {
  TopScoreNavCubit() : super(TopScoreRootState());

  void showTopScore() => emit(TopScoreRootState());

  void showTopScoreDetail(
    TRecord record,
    int? ranking,
    TPeriod period,
    bool isPersonalView,
  ) =>
      emit(
        TopScoreDetailState<TRecord, TPeriod>(
          record: record,
          ranking: ranking,
          period: period,
          isPersonalView: isPersonalView,
        ),
      );
}
