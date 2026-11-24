import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lich_am/data/backup_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackupService round-trip', () {
    test('xuất rồi nhập khôi phục đúng mọi kiểu dữ liệu', () async {
      SharedPreferences.setMockInitialValues({
        'birth_date': '1990-01-01T00:00:00.000',
        'profile_name': 'Nguyễn Văn A',
        'profile_gender': 'nu',
        'profile_hour': 5,
        'reminders': ['{"id":"1","title":"Giỗ","day":10,"month":5}'],
        'theme_mode': 'dark',
        'light_theme_id': 'sen_ngoc',
        'text_scale': 1.18,
        'glass_effect': false,
        'bg_enabled': true,
        'bg_opacity': 0.42,
      });

      final svc = BackupService();
      final json = await svc.exportJson();
      expect(json, contains('An Lich'));

      // Xoá sạch rồi khôi phục.
      SharedPreferences.setMockInitialValues({});
      final n = await svc.importJson(json);
      expect(n, 11);

      final p = await SharedPreferences.getInstance();
      expect(p.getString('birth_date'), '1990-01-01T00:00:00.000');
      expect(p.getString('profile_name'), 'Nguyễn Văn A');
      expect(p.getString('profile_gender'), 'nu');
      expect(p.getInt('profile_hour'), 5);
      expect(p.getStringList('reminders')!.length, 1);
      expect(p.getString('theme_mode'), 'dark');
      expect(p.getString('light_theme_id'), 'sen_ngoc');
      expect(p.getDouble('text_scale'), 1.18);
      expect(p.getBool('glass_effect'), false);
      expect(p.getBool('bg_enabled'), true);
      expect(p.getDouble('bg_opacity'), 0.42);
    });

    test('sửa mojibake UTF-8-đọc-nhầm-Latin-1 khi khôi phục', () async {
      // Giả lập tệp bị app trung gian double-encode: "Nguyễn" → "Nguyá»…n".
      String broken(String s) => latin1.decode(utf8.encode(s));
      expect(broken('Nguyễn'), isNot('Nguyễn')); // xác nhận fixture hỏng thật

      SharedPreferences.setMockInitialValues({
        'profile_name': broken('Nguyễn Quang Minh'),
        'reminders': [broken('{"title":"Giỗ ông ngoại","day":10,"month":5}')],
      });
      final svc = BackupService();
      final json = await svc.exportJson();

      SharedPreferences.setMockInitialValues({});
      await svc.importJson(json);
      final p = await SharedPreferences.getInstance();
      expect(p.getString('profile_name'), 'Nguyễn Quang Minh');
      expect(p.getStringList('reminders')!.first, contains('Giỗ ông ngoại'));
    });

    test('fixMojibake giữ nguyên chuỗi tiếng Việt bình thường', () {
      const good = 'Nguyễn Văn Đông · Giỗ 10/5 ÂL';
      expect(BackupService.fixMojibake(good), good);
      expect(BackupService.fixMojibake('plain ascii 123'), 'plain ascii 123');
      expect(BackupService.fixMojibake(''), '');
    });

    test('JSON sai định dạng ném FormatException', () async {
      SharedPreferences.setMockInitialValues({});
      final svc = BackupService();
      expect(() => svc.importJson('{"khong":"co data"}'),
          throwsA(isA<FormatException>()));
    });
  });
}
