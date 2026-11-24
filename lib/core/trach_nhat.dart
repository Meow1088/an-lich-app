/// Trạch nhật: chấm điểm ngày tốt/xấu theo từng VIỆC (THAM KHẢO).
/// Cộng dồn minh bạch từ lõi đã có: Hoàng/Hắc đạo + 12 Trực + Nhị thập bát tú
/// + ngày xấu cổ truyền (Tam Nương/Nguyệt kỵ/Dương Công/Sát chủ).
library;

import 'can_chi.dart';
import 'hoang_dao.dart';
import 'lunar_calendar.dart';
import 'ngay_xau.dart';
import 'truc_tu.dart';

/// Một loại việc cần xem ngày. keywords khớp trong Truc.nen/kieng (có sẵn).
class Viec {
  final String id;
  final String label;
  final List<String> keywords;
  final bool majorEvent; // việc lớn -> dính Tam Nương / Nguyệt kỵ
  final bool duongCong; // chịu phạt Dương Công
  final bool satChuDuong; // chịu phạt Sát chủ Dương
  final bool satChuAm; // chịu phạt Sát chủ Âm
  const Viec(this.id, this.label, this.keywords,
      {this.majorEvent = false,
      this.duongCong = false,
      this.satChuDuong = false,
      this.satChuAm = false});
}

const List<Viec> viecList = [
  Viec('cuoi_hoi', 'Cưới hỏi', ['cưới hỏi'],
      majorEvent: true, duongCong: true),
  Viec('dong_tho', 'Động thổ / Khởi công', ['động thổ', 'khởi công', 'xây dựng'],
      majorEvent: true, duongCong: true),
  Viec('nhap_trach', 'Nhập trạch (về nhà mới)', ['dời nhà'],
      majorEvent: true, duongCong: true),
  Viec('khai_truong', 'Khai trương / Mở cửa hàng',
      ['khai trương', 'mở cửa hàng', 'mở kho'],
      majorEvent: true, duongCong: true, satChuDuong: true),
  Viec('xuat_hanh', 'Xuất hành / Đi xa', ['xuất hành'], majorEvent: true),
  Viec('ky_ket', 'Ký kết / Giao dịch', ['ký kết', 'giao dịch'],
      satChuDuong: true),
  Viec('an_tang', 'An táng', ['an táng'], satChuAm: true),
  Viec('cau_tai', 'Cầu tài', ['cầu tài']),
  Viec('chua_benh', 'Chữa bệnh', ['chữa bệnh']),
  Viec('cung_le', 'Cúng lễ', ['cúng lễ']),
];

enum DayLevel { ratTot, tot, binh, xau, ratXau }

extension DayLevelLabel on DayLevel {
  String get label => switch (this) {
        DayLevel.ratTot => 'Rất tốt',
        DayLevel.tot => 'Tốt',
        DayLevel.binh => 'Bình',
        DayLevel.xau => 'Xấu',
        DayLevel.ratXau => 'Rất xấu',
      };
}

class DayScore {
  final int dd, mm, yy;
  final int score;
  final DayLevel level;
  final List<String> goodReasons;
  final List<String> badReasons;
  const DayScore(this.dd, this.mm, this.yy, this.score, this.level,
      this.goodReasons, this.badReasons);
}

DayLevel _levelOf(int s) {
  if (s >= 4) return DayLevel.ratTot;
  if (s >= 1) return DayLevel.tot;
  if (s == 0) return DayLevel.binh;
  if (s >= -3) return DayLevel.xau;
  return DayLevel.ratXau;
}

/// Chấm điểm một ngày dương lịch cho một việc.
DayScore scoreDay(Viec viec, int dd, int mm, int yy) {
  var score = 0;
  final good = <String>[];
  final bad = <String>[];

  // 1. Hoàng / Hắc đạo
  final dq = dayQuality(dd, mm, yy);
  if (dq.isHoangDao) {
    score += 2;
    good.add('Ngày Hoàng đạo (${dq.star})');
  } else {
    score -= 2;
    bad.add('Ngày Hắc đạo (${dq.star})');
  }

  // 2. Trực (so việc với nen/kieng có sẵn)
  final truc = trucOfDay(dd, mm, yy);
  final nen = truc.nen.toLowerCase();
  final kieng = truc.kieng.toLowerCase();
  if (viec.keywords.any(nen.contains)) {
    score += 2;
    good.add('Trực ${truc.name}: nên ${viec.label.toLowerCase()}');
  } else if (viec.keywords.any(kieng.contains)) {
    score -= 2;
    bad.add('Trực ${truc.name}: kỵ ${viec.label.toLowerCase()}');
  } else if (truc.isGood) {
    score += 1;
    good.add('Trực ${truc.name} (tốt)');
  } else if (truc.isBad) {
    score -= 1;
    bad.add('Trực ${truc.name} (xấu)');
  }

  // 3. Nhị thập bát tú
  final tu = tuOfDay(dd, mm, yy);
  if (tu.good) {
    score += 1;
    good.add('Sao ${tu.name} (cát)');
  } else {
    score -= 1;
    bad.add('Sao ${tu.name} (hung)');
  }

  // 4. Ngày xấu cổ truyền (chỉ áp dụng theo loại việc)
  final lunar = solarToLunar(dd, mm, yy);
  final dayChi = chiIndexOfDay(dd, mm, yy);
  if (viec.majorEvent && isTamNuong(lunar.day)) {
    score -= 2;
    bad.add('Ngày Tam Nương');
  }
  if (viec.majorEvent && isNguyetKy(lunar.day)) {
    score -= 2;
    bad.add('Ngày Nguyệt kỵ');
  }
  if (viec.duongCong && isDuongCong(lunar.day, lunar.month)) {
    score -= 3;
    bad.add('Dương Công kỵ nhật');
  }
  if (viec.satChuDuong && isSatChuDuong(dayChi, lunar.month)) {
    score -= 3;
    bad.add('Sát chủ Dương');
  }
  if (viec.satChuAm && isSatChuAm(dayChi, lunar.month)) {
    score -= 3;
    bad.add('Sát chủ Âm');
  }

  return DayScore(dd, mm, yy, score, _levelOf(score), good, bad);
}

/// Chấm điểm mọi ngày trong khoảng [from, to] (gồm 2 đầu), xếp giảm dần theo điểm.
/// Cùng điểm thì ngày sớm hơn lên trước.
List<DayScore> findGoodDays(Viec viec, DateTime from, DateTime to) {
  final result = <DayScore>[];
  var d = DateTime(from.year, from.month, from.day);
  final end = DateTime(to.year, to.month, to.day);
  while (!d.isAfter(end)) {
    result.add(scoreDay(viec, d.day, d.month, d.year));
    d = d.add(const Duration(days: 1));
  }
  result.sort((a, b) {
    final c = b.score.compareTo(a.score);
    if (c != 0) return c;
    return julianDayNumber(a.dd, a.mm, a.yy)
        .compareTo(julianDayNumber(b.dd, b.mm, b.yy));
  });
  return result;
}
