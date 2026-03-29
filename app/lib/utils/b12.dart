import 'package:flutter/material.dart';

final _b12Start = DateTime(2026, 3, 27);

bool isB12Day(DateTime date) {
  final diff = DateUtils.dateOnly(
    date,
  ).difference(DateUtils.dateOnly(_b12Start)).inDays;
  return diff >= 0 && diff % 14 == 0;
}

const b12Total = 40;

/// Returns the 1-based injection number for the given B12 day.
/// Returns 0 if the date is before the start date or not a B12 day.
int b12InjectionNumber(DateTime date) {
  final diff = DateUtils.dateOnly(
    date,
  ).difference(DateUtils.dateOnly(_b12Start)).inDays;
  if (diff < 0 || diff % 14 != 0) return 0;
  return (diff ~/ 14) + 1;
}

DateTime nextB12(DateTime from) {
  final daysSinceStart = DateUtils.dateOnly(
    from,
  ).difference(DateUtils.dateOnly(_b12Start)).inDays;
  if (daysSinceStart < 0) return _b12Start;
  final remainder = daysSinceStart % 14;
  if (remainder == 0) return DateUtils.dateOnly(from);
  return DateUtils.dateOnly(from).add(Duration(days: 14 - remainder));
}
