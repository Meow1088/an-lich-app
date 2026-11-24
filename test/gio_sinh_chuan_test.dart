import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/gio_sinh_chuan.dart';

void main() {
  group('muiGioGiay', () {
    int h(DateTime t, VungSinh v) => muiGioGiay(t, v) ~/ 3600;
    test('các mốc đã biết', () {
      expect(h(DateTime(1968, 1, 30, 10), VungSinh.nam), 8);
      expect(h(DateTime(1968, 1, 30, 10), VungSinh.bac), 7);
      expect(h(DateTime(1957, 5, 1), VungSinh.nam), 7);
      expect(h(DateTime(1975, 6, 12, 23), VungSinh.nam), 8);
      expect(h(DateTime(1975, 6, 13, 0, 30), VungSinh.nam), 7);
      for (final v in VungSinh.values) {
        expect(h(DateTime(1944, 6, 1), v), 8);
        expect(h(DateTime(1945, 6, 1), v), 9);
        expect(h(DateTime(2000, 1, 1), v), 7);
      }
      expect(h(DateTime(1950, 1, 1), VungSinh.bac), 8);
      expect(h(DateTime(1955, 1, 1), VungSinh.bac), 7);
      expect(muiGioGiay(DateTime(1900, 1, 1), VungSinh.nam), 25590);
    });
  });

  group('phuongTrinhThoiGianPhut', () {
    test('khớp NOAA trong ±1 phút', () {
      expect(phuongTrinhThoiGianPhut(DateTime.utc(2026, 2, 11, 12)),
          closeTo(-14.2, 1.0));
      expect(phuongTrinhThoiGianPhut(DateTime.utc(2026, 11, 3, 12)),
          closeTo(16.4, 1.0));
      expect(phuongTrinhThoiGianPhut(DateTime.utc(2026, 4, 15, 12)),
          closeTo(0.0, 1.0));
      expect(phuongTrinhThoiGianPhut(DateTime.utc(2026, 7, 26, 12)),
          closeTo(-6.5, 1.0));
    });
  });

  group('chiCuaGio', () {
    test('biên các chi', () {
      expect(chiCuaGio(23, 0), 0);
      expect(chiCuaGio(0, 59), 0);
      expect(chiCuaGio(1, 0), 1);
      expect(chiCuaGio(12, 30), 6);
      expect(chiCuaGio(22, 59), 11);
    });
  });

  group('chuanHoaGioSinh', () {
    test('1970 Nam: đồng hồ 01:30 (+8) = giờ chuẩn 00:30 Tý', () {
      final r = chuanHoaGioSinh(DateTime(1970, 3, 10, 1, 30),
          vung: VungSinh.nam, kinhDo: 106.7);
      expect(r.gioChuan, DateTime(1970, 3, 10, 0, 30));
      expect(r.chiChuan, 0);
    });

    test('Tý muộn: ngày lập lá số', () {
      final t = DateTime(1968, 1, 30, 0, 30);
      final a = chuanHoaGioSinh(t, vung: VungSinh.nam, kinhDo: 106.7);
      expect(a.gioChuan, DateTime(1968, 1, 29, 23, 30));
      expect(a.ngayLapLaSo, DateTime(1968, 1, 29));
      final b = chuanHoaGioSinh(t,
          vung: VungSinh.nam, kinhDo: 106.7, tyMuonSangHomSau: true);
      expect(b.ngayLapLaSo, DateTime(1968, 1, 30));
    });

    test('2026-11-03 12:00 Nam: lệch mặt trời ~23 phút, không sát ranh', () {
      final r = chuanHoaGioSinh(DateTime(2026, 11, 3, 12),
          vung: VungSinh.nam, kinhDo: 106.7);
      expect(r.lechMatTroiPhut, closeTo(23.2, 1.5));
      expect(r.chiChuan, 6);
      expect(r.chiMatTroi, 6);
      expect(r.satRanh, isFalse);
    });

    test('2026-11-03 10:50 Nam: Tỵ theo giờ chuẩn, Ngọ theo mặt trời', () {
      final r = chuanHoaGioSinh(DateTime(2026, 11, 3, 10, 50),
          vung: VungSinh.nam, kinhDo: 106.7);
      expect(r.chiChuan, 5);
      expect(r.chiMatTroi, 6);
      expect(r.satRanh, isTrue);
    });

    test('2000-05-05 23:30 Bắc: tyMuonSangHomSau đổi ngày lập lá số', () {
      final t = DateTime(2000, 5, 5, 23, 30);
      expect(
          chuanHoaGioSinh(t, vung: VungSinh.bac, kinhDo: 105.8).ngayLapLaSo,
          DateTime(2000, 5, 5));
      expect(
          chuanHoaGioSinh(t,
                  vung: VungSinh.bac, kinhDo: 105.8, tyMuonSangHomSau: true)
              .ngayLapLaSo,
          DateTime(2000, 5, 6));
    });
  });
}
