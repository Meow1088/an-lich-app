import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lich_am/data/profile_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chưa có hồ sơ -> load trả null', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await ProfileStore().load(), isNull);
  });

  test('lưu rồi đọc lại đúng các trường', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(
      name: 'Nguyễn A',
      birthDate: DateTime(1990, 5, 12),
      gender: Gender.nu,
      hourChi: 3,
    ));
    final p = await store.load();
    expect(p, isNotNull);
    expect(p!.name, 'Nguyễn A');
    expect(p.birthDate, DateTime(1990, 5, 12));
    expect(p.gender, Gender.nu);
    expect(p.hourChi, 3);
  });

  test('giờ không rõ lưu -1 -> đọc null', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(birthDate: DateTime(2000, 1, 1)));
    final p = await store.load();
    expect(p!.hourChi, isNull);
    expect(p.gender, Gender.nam); // mặc định
  });

  test('lưu/đọc độ tin cậy giờ sinh = ước lượng', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(
      birthDate: DateTime(1995, 7, 7),
      hourChi: 5,
      hourConf: HourConfidence.uocLuong,
    ));
    final p = await store.load();
    expect(p!.hourChi, 5);
    expect(p.hourConf, HourConfidence.uocLuong);
  });

  test('không biết giờ -> hourConf khongBiet + hourChi null', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(
      birthDate: DateTime(1995, 7, 7),
      hourConf: HourConfidence.khongBiet,
    ));
    final p = await store.load();
    expect(p!.hourChi, isNull);
    expect(p.hourConf, HourConfidence.khongBiet);
  });

  test('back-compat: bản cũ có giờ nhưng thiếu khoá conf -> chinhXac', () async {
    SharedPreferences.setMockInitialValues({
      'birth_date': DateTime(1980, 1, 1).toIso8601String(),
      'profile_hour': 4,
    });
    final p = await ProfileStore().load();
    expect(p!.hourChi, 4);
    expect(p.hourConf, HourConfidence.chinhXac);
  });

  test('back-compat: bản cũ không giờ (-1) -> khongBiet', () async {
    SharedPreferences.setMockInitialValues({
      'birth_date': DateTime(1980, 1, 1).toIso8601String(),
      'profile_hour': -1,
    });
    final p = await ProfileStore().load();
    expect(p!.hourChi, isNull);
    expect(p.hourConf, HourConfidence.khongBiet);
  });

  test('dùng chung khoá birth_date với biorhythm', () async {
    SharedPreferences.setMockInitialValues(
        {'birth_date': DateTime(1985, 3, 3).toIso8601String()});
    final p = await ProfileStore().load();
    expect(p, isNotNull);
    expect(p!.birthDate, DateTime(1985, 3, 3));
  });

  test('chính chủ luôn có id = self, relation = Bản thân', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(birthDate: DateTime(1990, 1, 1)));
    final p = await store.load();
    expect(p!.id, kSelfId);
    expect(p.isSelf, isTrue);
    expect(p.relation, kSelfRelation);
  });

  test('Profile toJson/fromJson roundtrip giữ nguyên trường', () {
    final r = Profile(
      id: 'abc123',
      relation: 'Mẹ',
      name: 'Trần B',
      birthDate: DateTime(1965, 8, 20),
      gender: Gender.nu,
      hourChi: 7,
      hourConf: HourConfidence.uocLuong,
    );
    final back = Profile.fromJson(r.toJson());
    expect(back.id, 'abc123');
    expect(back.relation, 'Mẹ');
    expect(back.name, 'Trần B');
    expect(back.birthDate, DateTime(1965, 8, 20));
    expect(back.gender, Gender.nu);
    expect(back.hourChi, 7);
    expect(back.hourConf, HourConfidence.uocLuong);
  });

  test('thêm người thân -> loadRelatives trả về đúng', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.upsertRelative(Profile(
      id: 'r1',
      relation: 'Bố',
      name: 'Ông A',
      birthDate: DateTime(1960, 2, 2),
    ));
    final rel = await store.loadRelatives();
    expect(rel, hasLength(1));
    expect(rel.first.relation, 'Bố');
    expect(rel.first.name, 'Ông A');
  });

  test('upsertRelative cùng id -> cập nhật, không nhân đôi', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.upsertRelative(
        Profile(id: 'r1', relation: 'Con', birthDate: DateTime(2010, 1, 1)));
    await store.upsertRelative(Profile(
        id: 'r1', relation: 'Con', name: 'Bé Bi', birthDate: DateTime(2010, 1, 1)));
    final rel = await store.loadRelatives();
    expect(rel, hasLength(1));
    expect(rel.first.name, 'Bé Bi');
  });

  test('loadAll: chính chủ đứng đầu, rồi tới người thân', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.save(Profile(name: 'Tôi', birthDate: DateTime(1990, 1, 1)));
    await store.upsertRelative(
        Profile(id: 'r1', relation: 'Mẹ', birthDate: DateTime(1965, 1, 1)));
    await store.upsertRelative(
        Profile(id: 'r2', relation: 'Con', birthDate: DateTime(2015, 1, 1)));
    final all = await store.loadAll();
    expect(all, hasLength(3));
    expect(all.first.isSelf, isTrue);
    expect(all[1].id, 'r1');
    expect(all[2].id, 'r2');
  });

  test('loadAll rỗng khi chưa có chính chủ (dù có JSON người thân)', () async {
    SharedPreferences.setMockInitialValues(
        {'relatives_json': '[{"id":"r1","relation":"Bố","birth":"1960-01-01T00:00:00.000"}]'});
    final all = await ProfileStore().loadAll();
    expect(all, isEmpty);
  });

  test('deleteRelative xoá đúng id', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ProfileStore();
    await store.upsertRelative(
        Profile(id: 'r1', relation: 'Bố', birthDate: DateTime(1960, 1, 1)));
    await store.upsertRelative(
        Profile(id: 'r2', relation: 'Mẹ', birthDate: DateTime(1965, 1, 1)));
    await store.deleteRelative('r1');
    final rel = await store.loadRelatives();
    expect(rel, hasLength(1));
    expect(rel.first.id, 'r2');
  });

  test('JSON người thân hỏng -> loadRelatives trả rỗng (không crash)', () async {
    SharedPreferences.setMockInitialValues({'relatives_json': 'not-json{['});
    final rel = await ProfileStore().loadRelatives();
    expect(rel, isEmpty);
  });
}
