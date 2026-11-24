import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lich_am/core/noi_sinh_data.dart';
import 'package:lich_am/data/profile_store.dart';
import 'package:lich_am/data/settings_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ngayLapLaSo', () {
    test('không có giờ:phút -> giữ nguyên ngày', () {
      expect(ngayLapLaSo(birthDate: DateTime(1968, 1, 30, 15, 4)),
          DateTime(1968, 1, 30));
    });

    test('Nam 1968-01-30 00:30 (UTC+8) -> lùi về 29', () {
      expect(
          ngayLapLaSo(
              birthDate: DateTime(1968, 1, 30),
              gioPhut: 30,
              noiSinh: 'TP. Hồ Chí Minh'),
          DateTime(1968, 1, 29));
    });

    test('Tý muộn: mặc định cùng ngày, bật cờ -> ngày sau', () {
      final d = DateTime(2000, 5, 5);
      expect(
          ngayLapLaSo(
              birthDate: d, gioPhut: 23 * 60 + 30, noiSinh: 'Hà Nội'),
          DateTime(2000, 5, 5));
      expect(
          ngayLapLaSo(
              birthDate: d,
              gioPhut: 23 * 60 + 30,
              noiSinh: 'Hà Nội',
              tyMuonSangHomSau: true),
          DateTime(2000, 5, 6));
    });

    test('không rõ nơi sinh: không chỉnh múi giờ, chỉ xét Tý muộn', () {
      final d = DateTime(2000, 5, 5);
      expect(
          ngayLapLaSo(
              birthDate: d, gioPhut: 23 * 60 + 10, tyMuonSangHomSau: true),
          DateTime(2000, 5, 6));
      expect(
          ngayLapLaSo(
              birthDate: d,
              gioPhut: 23 * 60 + 10,
              noiSinh: 'Không có',
              tyMuonSangHomSau: true),
          DateTime(2000, 5, 6));
      expect(ngayLapLaSo(birthDate: d, gioPhut: 22 * 60, tyMuonSangHomSau: true),
          d);
    });
  });

  group('Profile gioPhut/noiSinh', () {
    test('JSON round trip', () {
      final p = Profile(
          birthDate: DateTime(1990, 5, 12),
          hourChi: 3,
          gioPhut: 345,
          noiSinh: 'Hà Nội');
      final q = Profile.fromJson(p.toJson());
      expect(q.gioPhut, 345);
      expect(q.noiSinh, 'Hà Nội');
    });

    test('JSON cũ không có khoá -> null', () {
      final q = Profile.fromJson({
        'id': 'x',
        'birth': DateTime(1990, 5, 12).toIso8601String(),
        'hourChi': 3,
        'hourConf': 'chinhXac',
      });
      expect(q.gioPhut, isNull);
      expect(q.noiSinh, isNull);
      expect(q.hourChi, 3);
    });

    test('copyWith clear flags', () {
      final p = Profile(
          birthDate: DateTime(1990, 5, 12), gioPhut: 10, noiSinh: 'Hà Nội');
      final q = p.copyWith(clearGioPhut: true, clearNoiSinh: true);
      expect(q.gioPhut, isNull);
      expect(q.noiSinh, isNull);
    });
  });

  group('ProfileStore chính chủ', () {
    test('lưu rồi đọc lại gioPhut/noiSinh; xoá thì về null', () async {
      SharedPreferences.setMockInitialValues({});
      final store = ProfileStore();
      await store.save(Profile(
          birthDate: DateTime(1990, 5, 12),
          hourChi: 3,
          gioPhut: 345,
          noiSinh: 'Hà Nội'));
      var p = await store.load();
      expect(p!.gioPhut, 345);
      expect(p.noiSinh, 'Hà Nội');
      await store.save(Profile(birthDate: DateTime(1990, 5, 12), hourChi: 3));
      p = await store.load();
      expect(p!.gioPhut, isNull);
      expect(p.noiSinh, isNull);
    });
  });

  test('SettingsStore Tý muộn: mặc định false, set true -> true', () async {
    SharedPreferences.setMockInitialValues({});
    final s = SettingsStore();
    expect(await s.getTyMuonSangHomSau(), isFalse);
    await s.setTyMuonSangHomSau(true);
    expect(await s.getTyMuonSangHomSau(), isTrue);
  });
}
