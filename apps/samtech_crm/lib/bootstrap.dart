import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// Initializes Flutter and mounts the root Riverpod container.
Future<void> bootstrap({FutureOr<void> Function()? beforeRunApp}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await beforeRunApp?.call();
  runApp(const ProviderScope(child: SamtechApp()));
}
