import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../memorization/review_calendar.dart';
import 'wird_plan.dart';

/// The user's Wird settings and where they stand in the loop.
class WirdState {
  const WirdState({
    this.loaded = false,
    this.unit = WirdUnit.pages,
    this.amount,
    this.pointer = 0,
    this.turnsDone = 0,
    this.lastDoneDay,
  });

  final bool loaded;
  final WirdUnit unit;

  /// The daily goal in [unit]; null until the user has chosen one (a goal is
  /// then suggested from the size of the loop).
  final int? amount;

  /// The last page read in the current round (0 at the start of a round).
  final int pointer;

  /// Rounds of the loop completed.
  final int turnsDone;

  /// The last day a share was read.
  final DateTime? lastDoneDay;

  WirdState copyWith({
    WirdUnit? unit,
    int? amount,
    int? pointer,
    int? turnsDone,
    DateTime? lastDoneDay,
  }) => WirdState(
    loaded: true,
    unit: unit ?? this.unit,
    amount: amount ?? this.amount,
    pointer: pointer ?? this.pointer,
    turnsDone: turnsDone ?? this.turnsDone,
    lastDoneDay: lastDoneDay ?? this.lastDoneDay,
  );
}

const _kUnit = 'wird.unit';
const _kAmount = 'wird.amount';
const _kPointer = 'wird.pointer';
const _kTurns = 'wird.turns';
const _kLastDone = 'wird.lastDone';

String _dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime? _parseDay(String? s) {
  if (s == null) return null;
  final parts = s.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

class WirdController extends Notifier<WirdState> {
  /// Saving before the stored settings are read would lose them.
  late Future<void> _restoring;

  @override
  WirdState build() {
    _restoring = _restore();
    return const WirdState();
  }

  Future<void> _restore() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Storage unavailable: the Wird starts from its defaults.
    }
    if (!ref.mounted) return;
    final unit = WirdUnit.values.asNameMap()[prefs?.getString(_kUnit)];
    final resolved = unit ?? WirdUnit.pages;
    final amount = prefs?.getInt(_kAmount);
    state = WirdState(
      loaded: true,
      unit: resolved,
      amount: amount != null && amount >= 1 && amount <= maxWirdAmount(resolved)
          ? amount
          : null,
      pointer: prefs?.getInt(_kPointer) ?? 0,
      turnsDone: prefs?.getInt(_kTurns) ?? 0,
      lastDoneDay: _parseDay(prefs?.getString(_kLastDone)),
    );
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kUnit, state.unit.name);
      if (state.amount != null) await prefs.setInt(_kAmount, state.amount!);
      await prefs.setInt(_kPointer, state.pointer);
      await prefs.setInt(_kTurns, state.turnsDone);
      if (state.lastDoneDay != null) {
        await prefs.setString(_kLastDone, _dayKey(state.lastDoneDay!));
      }
    } catch (_) {
      // Not being able to save is not worth interrupting for.
    }
  }

  /// Sets the daily goal; [amount] is kept within what the unit allows.
  Future<void> setGoal(WirdUnit unit, int amount) async {
    await _restoring;
    state = state.copyWith(
      unit: unit,
      amount: amount.clamp(1, maxWirdAmount(unit)),
    );
    await _save();
  }

  /// A share was read: the loop moves on and today is done.
  Future<void> completeShare({
    required int pointer,
    required int turnsDone,
    required DateTime today,
  }) async {
    await _restoring;
    state = state.copyWith(
      pointer: pointer,
      turnsDone: turnsDone,
      lastDoneDay: dateOnly(today),
    );
    await _save();
  }
}

final wirdControllerProvider = NotifierProvider<WirdController, WirdState>(
  WirdController.new,
);
