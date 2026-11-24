import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lich_am/data/settings_store.dart';
import 'package:lich_am/ui/pin_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('hashPin', () {
    test('cùng PIN -> cùng hash (tất định)', () {
      expect(hashPin('1234'), hashPin('1234'));
    });

    test('khác PIN -> khác hash', () {
      expect(hashPin('1234'), isNot(hashPin('4321')));
    });

    test('không trả về chính PIN gốc', () {
      expect(hashPin('1234'), isNot(contains('1234')));
    });
  });

  group('SettingsStore PIN', () {
    test('chưa đặt PIN -> getPinHash trả null', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await SettingsStore().getPinHash(), isNull);
    });

    test('đặt rồi đọc lại đúng hash', () async {
      SharedPreferences.setMockInitialValues({});
      final store = SettingsStore();
      final h = hashPin('5678');
      await store.setPinHash(h);
      expect(await store.getPinHash(), h);
    });

    test('setPinHash(null) xóa PIN đã đặt (tắt khóa)', () async {
      SharedPreferences.setMockInitialValues({});
      final store = SettingsStore();
      await store.setPinHash(hashPin('5678'));
      await store.setPinHash(null);
      expect(await store.getPinHash(), isNull);
    });
  });
}
