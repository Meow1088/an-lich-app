/// Âm lịch Việt Nam — port giải thuật của Hồ Ngọc Đức (amlich, MIT).
/// Tính theo kinh tuyến 105°Đ → múi giờ UTC+7 (mặc định cho Việt Nam).
///
/// Nguồn thuật toán: https://www.informatik.uni-leipzig.de/~duc/amlich/
/// Đây là giải thuật thiên văn chuẩn de-facto cho lịch âm VN — KHÔNG tự chế.
library;

import 'dart:math';

/// Múi giờ Việt Nam (giờ).
const double vnTimeZone = 7.0;

/// Một ngày âm lịch.
class LunarDate {
  final int day;
  final int month;
  final int year;
  final bool isLeapMonth;

  const LunarDate(this.day, this.month, this.year, {this.isLeapMonth = false});

  @override
  String toString() => '$day/$month/$year${isLeapMonth ? ' (nhuận)' : ''}';

  @override
  bool operator ==(Object other) =>
      other is LunarDate &&
      other.day == day &&
      other.month == month &&
      other.year == year &&
      other.isLeapMonth == isLeapMonth;

  @override
  int get hashCode => Object.hash(day, month, year, isLeapMonth);
}

/// Julian Day Number của một ngày dương lịch (giờ địa phương, số nguyên).
/// Dùng cho tính can chi của ngày.
int julianDayNumber(int dd, int mm, int yy) {
  final a = (14 - mm) ~/ 12;
  final y = yy + 4800 - a;
  final m = mm + 12 * a - 3;
  var jd = dd +
      ((153 * m + 2) ~/ 5) +
      365 * y +
      (y ~/ 4) -
      (y ~/ 100) +
      (y ~/ 400) -
      32045;
  if (jd < 2299161) {
    jd = dd + ((153 * m + 2) ~/ 5) + 365 * y + (y ~/ 4) - 32083;
  }
  return jd;
}

/// Đảo ngược: từ Julian Day Number ra [day, month, year] dương lịch.
List<int> jdToDate(int jd) {
  int a, b, c;
  if (jd > 2299160) {
    a = jd + 32044;
    b = (4 * a + 3) ~/ 146097;
    c = a - (b * 146097) ~/ 4;
  } else {
    b = 0;
    c = jd + 32082;
  }
  final d = (4 * c + 3) ~/ 1461;
  final e = c - (1461 * d) ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  final day = e - (153 * m + 2) ~/ 5 + 1;
  final month = m + 3 - 12 * (m ~/ 10);
  final year = b * 100 + d - 4800 + (m ~/ 10);
  return [day, month, year];
}

/// Thời điểm sóc (new moon) thứ k tính từ điểm gốc 1/1/1900.
double _newMoon(int k) {
  final t = k / 1236.85;
  final t2 = t * t;
  final t3 = t2 * t;
  const dr = pi / 180;
  var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 = jd1 + 0.00033 * sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);
  final m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
  final mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
  final f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
  var c1 = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * dr * m);
  c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
  c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
  c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr));
  c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m));
  c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr));
  c1 = c1 + 0.0010 * sin(dr * (2 * f - mpr)) + 0.0005 * sin(dr * (2 * mpr + m));
  double deltat;
  if (t < -11) {
    deltat = 0.001 +
        0.000839 * t +
        0.0002261 * t2 -
        0.00000845 * t3 -
        0.000000081 * t * t3;
  } else {
    deltat = -0.000278 + 0.000265 * t + 0.000262 * t2;
  }
  return jd1 + c1 - deltat;
}

/// Kinh độ mặt trời (radian) tại thời điểm Julian jdn.
double sunLongitudeRad(double jdn) {
  final t = (jdn - 2451545.0) / 36525;
  final t2 = t * t;
  const dr = pi / 180;
  final m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
  final l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
  var dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m);
  dl = dl +
      (0.019993 - 0.000101 * t) * sin(dr * 2 * m) +
      0.000290 * sin(dr * 3 * m);
  var l = l0 + dl;
  l = l * dr;
  l = l - 2 * pi * (l / (2 * pi)).floor();
  return l;
}

/// Cung kinh độ mặt trời theo bước 30° (0..11) — dùng để xác định tháng âm.
int _sunLongitude12(int dayNumber, double timeZone) {
  return (sunLongitudeRad(dayNumber - 0.5 - timeZone / 24) / pi * 6).floor();
}

/// Ngày (số nguyên, giờ địa phương) của sóc thứ k.
int _newMoonDay(int k, double timeZone) {
  return (_newMoon(k) + 0.5 + timeZone / 24).floor();
}

/// Ngày bắt đầu tháng 11 âm lịch (tháng chứa Đông chí) của năm dương yy.
int _lunarMonth11(int yy, double timeZone) {
  final off = julianDayNumber(31, 12, yy) - 2415021;
  final k = (off / 29.530588853).floor();
  var nm = _newMoonDay(k, timeZone);
  if (_sunLongitude12(nm, timeZone) >= 9) {
    nm = _newMoonDay(k - 1, timeZone);
  }
  return nm;
}

/// Vị trí tháng nhuận tính từ tháng 11.
int _leapMonthOffset(int a11, double timeZone) {
  final k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor();
  var last = 0;
  var i = 1;
  var arc = _sunLongitude12(_newMoonDay(k + i, timeZone), timeZone);
  do {
    last = arc;
    i++;
    arc = _sunLongitude12(_newMoonDay(k + i, timeZone), timeZone);
  } while (arc != last && i < 14);
  return i - 1;
}

/// Chuyển ngày dương lịch -> âm lịch (Việt Nam, UTC+7 mặc định).
LunarDate solarToLunar(int dd, int mm, int yy, {double timeZone = vnTimeZone}) {
  final dayNumber = julianDayNumber(dd, mm, yy);
  final k = ((dayNumber - 2415021.076998695) / 29.530588853).floor();
  var monthStart = _newMoonDay(k + 1, timeZone);
  if (monthStart > dayNumber) {
    monthStart = _newMoonDay(k, timeZone);
  }
  var a11 = _lunarMonth11(yy, timeZone);
  var b11 = a11;
  int lunarYear;
  if (a11 >= monthStart) {
    lunarYear = yy;
    a11 = _lunarMonth11(yy - 1, timeZone);
  } else {
    lunarYear = yy + 1;
    b11 = _lunarMonth11(yy + 1, timeZone);
  }
  final lunarDay = dayNumber - monthStart + 1;
  final diff = ((monthStart - a11) / 29).floor();
  var lunarLeap = false;
  var lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    final leapMonthDiff = _leapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) {
        lunarLeap = true;
      }
    }
  }
  if (lunarMonth > 12) {
    lunarMonth = lunarMonth - 12;
  }
  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }
  return LunarDate(lunarDay, lunarMonth, lunarYear, isLeapMonth: lunarLeap);
}

/// Chuyển âm lịch -> dương lịch. Trả về DateTime (giờ 12:00 tránh lệch ngày).
/// Trả về null nếu tháng nhuận không hợp lệ.
DateTime? lunarToSolar(int lunarDay, int lunarMonth, int lunarYear,
    {bool isLeapMonth = false, double timeZone = vnTimeZone}) {
  int a11, b11;
  if (lunarMonth < 11) {
    a11 = _lunarMonth11(lunarYear - 1, timeZone);
    b11 = _lunarMonth11(lunarYear, timeZone);
  } else {
    a11 = _lunarMonth11(lunarYear, timeZone);
    b11 = _lunarMonth11(lunarYear + 1, timeZone);
  }
  final k = (0.5 + (a11 - 2415021.076998695) / 29.530588853).floor();
  var off = lunarMonth - 11;
  if (off < 0) {
    off += 12;
  }
  if (b11 - a11 > 365) {
    final leapOff = _leapMonthOffset(a11, timeZone);
    var leapMonth = leapOff - 2;
    if (leapMonth < 0) {
      leapMonth += 12;
    }
    if (isLeapMonth && lunarMonth != leapMonth) {
      return null;
    } else if (isLeapMonth || off >= leapOff) {
      off += 1;
    }
  }
  final monthStart = _newMoonDay(k + off, timeZone);
  final d = jdToDate(monthStart + lunarDay - 1);
  return DateTime(d[2], d[1], d[0], 12);
}
