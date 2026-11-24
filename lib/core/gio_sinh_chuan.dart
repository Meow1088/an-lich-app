/// Chuẩn hóa giờ sinh về giờ chuẩn UTC+7 và giờ mặt trời thật (THAM KHẢO / giải trí).
/// Nguồn múi giờ: IANA tz Asia/Ho_Chi_Minh (Nam) + backzone Asia/Hanoi (Bắc).
/// Giờ mặt trời = UTC + kinh độ*4 phút + phương trình thời gian (NOAA).
library;

import 'dart:math' as math;

enum VungSinh { bac, nam }

/// Một đoạn múi giờ: offset (giây) áp dụng cho tới giờ đồng hồ [den] (tính theo offset cũ).
typedef _Doan = (DateTime den, int giay);

const int _h = 3600;

// ponytail: gap/overlap tại mốc chuyển múi giờ lấy offset CŨ (sớm hơn), không xử lý giờ mơ hồ.
final List<_Doan> _chung = [
  (DateTime.utc(1911, 5, 1), 25590),
  (DateTime.utc(1942, 12, 31, 23), 7 * _h),
  (DateTime.utc(1945, 3, 14, 23), 8 * _h),
  (DateTime.utc(1945, 9, 2), 9 * _h),
  (DateTime.utc(1947, 4, 1), 7 * _h),
];

// ponytail: IANA chỉ ghi "1954 Oct" cho miền Bắc, ngày 01 là ước lệ; đổi nếu có nguồn chính xác.
final List<_Doan> _bacThem = [(DateTime.utc(1954, 10, 1), 8 * _h)];

final List<_Doan> _namThem = [
  (DateTime.utc(1955, 7, 1, 1), 8 * _h),
  (DateTime.utc(1959, 12, 31, 23), 7 * _h),
  (DateTime.utc(1975, 6, 13), 8 * _h),
];

/// Offset múi giờ (giây) đang áp dụng ở VN cho một giờ đồng hồ (wall clock) tại vùng.
int muiGioGiay(DateTime gioDongHo, VungSinh vung) {
  final t = DateTime.utc(gioDongHo.year, gioDongHo.month, gioDongHo.day,
      gioDongHo.hour, gioDongHo.minute, gioDongHo.second);
  final bang = [..._chung, ...(vung == VungSinh.bac ? _bacThem : _namThem)];
  for (final d in bang) {
    if (t.isBefore(d.$1)) return d.$2;
  }
  return 7 * _h;
}

/// Phương trình thời gian NOAA, phút, tại thời điểm UTC.
double phuongTrinhThoiGianPhut(DateTime utc) {
  final u = utc.toUtc();
  final ngayDauNam = DateTime.utc(u.year);
  final ngayThu = u.difference(ngayDauNam).inDays + 1;
  final namNhuan = (u.year % 4 == 0 && u.year % 100 != 0) || u.year % 400 == 0;
  final soNgay = namNhuan ? 366 : 365;
  final g = 2 * math.pi / soNgay * (ngayThu - 1 + (u.hour - 12) / 24);
  return 229.18 *
      (0.000075 +
          0.001868 * math.cos(g) -
          0.032077 * math.sin(g) -
          0.014615 * math.cos(2 * g) -
          0.040849 * math.sin(2 * g));
}

/// Chi giờ 0..11 (Tý..Hợi) từ giờ:phút. 23:00–00:59 = 0, 01:00–02:59 = 1, ..., 21:00–22:59 = 11.
int chiCuaGio(int gio, int phut) => ((gio + 1) ~/ 2) % 12;

class KetQuaGioSinh {
  /// Giờ chuẩn UTC+7 (DateTime "naive", không isUtc).
  final DateTime gioChuan;
  final int chiChuan;

  /// Giờ mặt trời thật (naive).
  final DateTime gioMatTroi;
  final int chiMatTroi;

  /// gioMatTroi - gioChuan, phút.
  final double lechMatTroiPhut;

  /// Chỉ phần ngày (00:00) dùng lập lá số; xem quy tắc Tý muộn.
  final DateTime ngayLapLaSo;

  const KetQuaGioSinh({
    required this.gioChuan,
    required this.chiChuan,
    required this.gioMatTroi,
    required this.chiMatTroi,
    required this.lechMatTroiPhut,
    required this.ngayLapLaSo,
  });

  /// Giờ sinh sát ranh: chi theo giờ chuẩn khác chi theo mặt trời.
  bool get satRanh => chiChuan != chiMatTroi;
}

DateTime _naive(DateTime u) =>
    DateTime(u.year, u.month, u.day, u.hour, u.minute, u.second);

/// Chuẩn hóa giờ đồng hồ [gioDongHo] (naive) tại [vung] về giờ chuẩn UTC+7 và giờ mặt trời.
/// [tyMuonSangHomSau]: giờ Tý muộn (23:00–23:59) tính sang ngày hôm sau khi lập lá số.
KetQuaGioSinh chuanHoaGioSinh(DateTime gioDongHo,
    {required VungSinh vung,
    required double kinhDo,
    bool tyMuonSangHomSau = false}) {
  final mui = muiGioGiay(gioDongHo, vung);
  final utc = DateTime.utc(gioDongHo.year, gioDongHo.month, gioDongHo.day,
          gioDongHo.hour, gioDongHo.minute, gioDongHo.second)
      .subtract(Duration(seconds: mui));
  final chuan = utc.add(const Duration(hours: 7));
  final lech = kinhDo * 4 + phuongTrinhThoiGianPhut(utc);
  final matTroi = utc.add(Duration(microseconds: (lech * 60e6).round()));
  final gioChuan = _naive(chuan);
  final gioMatTroi = _naive(matTroi);
  var ngay = DateTime(gioChuan.year, gioChuan.month, gioChuan.day);
  if (tyMuonSangHomSau && gioChuan.hour == 23) {
    ngay = DateTime(ngay.year, ngay.month, ngay.day + 1);
  }
  return KetQuaGioSinh(
    gioChuan: gioChuan,
    chiChuan: chiCuaGio(gioChuan.hour, gioChuan.minute),
    gioMatTroi: gioMatTroi,
    chiMatTroi: chiCuaGio(gioMatTroi.hour, gioMatTroi.minute),
    lechMatTroiPhut: matTroi.difference(chuan).inMicroseconds / 60e6,
    ngayLapLaSo: ngay,
  );
}
