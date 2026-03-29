import 'dart:math';

import 'package:drift/drift.dart';

import '../database/local_database.dart';

/// Returns a persisted device ID, generating one on first call.
Future<String> getOrCreateDeviceId(AppLocalDatabase db) async {
  final row = await (db.select(
    db.keyValue,
  )..where((t) => t.key.equals('device_id'))).getSingleOrNull();
  if (row != null) return row.value;

  final id = _generateUuid();
  await db
      .into(db.keyValue)
      .insert(
        KeyValueCompanion.insert(key: 'device_id', value: id),
        mode: InsertMode.insertOrIgnore,
      );
  // Re-read in case a concurrent call won the race.
  final saved = await (db.select(
    db.keyValue,
  )..where((t) => t.key.equals('device_id'))).getSingle();
  return saved.value;
}

/// Simple v4 UUID generator (no external dependency).
String _generateUuid() {
  final rng = Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1
  return [
    _hex(bytes, 0, 4),
    _hex(bytes, 4, 6),
    _hex(bytes, 6, 8),
    _hex(bytes, 8, 10),
    _hex(bytes, 10, 16),
  ].join('-');
}

String _hex(List<int> bytes, int start, int end) => bytes
    .sublist(start, end)
    .map((b) => b.toRadixString(16).padLeft(2, '0'))
    .join();
