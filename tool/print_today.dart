// ignore_for_file: avoid_print
import 'package:lich_am/core/lunar_calendar.dart';
import 'package:lich_am/core/can_chi.dart';
import 'package:lich_am/core/hoang_dao.dart';

void main() {
  final d = DateTime(2026, 6, 24);
  final l = solarToLunar(d.day, d.month, d.year);
  final q = dayQuality(d.day, d.month, d.year);
  final hours = luckyHours(d.day, d.month, d.year);
  print('Duong: ${d.day}/${d.month}/${d.year}');
  print('Am: ${l.day}/${l.month}/${l.year} leap=${l.isLeapMonth}');
  print('Can chi ngay: ${canChiOfDay(d.day, d.month, d.year)}');
  print('Can chi thang: ${canChiOfMonth(l.month, l.year)}');
  print('Can chi nam: ${canChiOfYear(l.year)}');
  print('Tiet khi: ${tietKhiOfDay(d.day, d.month, d.year)}');
  print('Hoang dao: ${q.label} - sao ${q.star}');
  print('Gio hoang dao: ${hours.map((h) => "${h.chi}(${h.range})").join(", ")}');
}
