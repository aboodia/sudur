import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/reminders/reminder_sync.dart';

void main() {
  runApp(const ProviderScope(child: ReminderSyncHost(child: SudurApp())));
}
