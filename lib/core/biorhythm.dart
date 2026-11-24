/// Biorhythm — đồ thị vận mệnh hình sin.
/// 3 chu kỳ: thể chất 23 ngày, cảm xúc 28 ngày, trí tuệ 33 ngày.
library;

import 'dart:math';

const int physicalPeriod = 23;
const int emotionalPeriod = 28;
const int intellectualPeriod = 33;

/// Số ngày từ ngày sinh tới ngày đích (theo ngày dương lịch, bỏ phần giờ).
int daysSinceBirth(DateTime birth, DateTime target) {
  final b = DateTime(birth.year, birth.month, birth.day);
  final t = DateTime(target.year, target.month, target.day);
  return t.difference(b).inDays;
}

/// Giá trị một chu kỳ tại ngày target, trong [-1, 1].
double cycleValue(DateTime birth, DateTime target, int period) {
  final days = daysSinceBirth(birth, target);
  return sin(2 * pi * days / period);
}

double physical(DateTime birth, DateTime target) =>
    cycleValue(birth, target, physicalPeriod);
double emotional(DateTime birth, DateTime target) =>
    cycleValue(birth, target, emotionalPeriod);
double intellectual(DateTime birth, DateTime target) =>
    cycleValue(birth, target, intellectualPeriod);
