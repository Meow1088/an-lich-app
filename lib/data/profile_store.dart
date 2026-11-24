import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum Gender { nam, nu }

extension GenderLabel on Gender {
  String get label => this == Gender.nam ? 'Nam' : 'Nữ';
}

/// Độ tin cậy của giờ sinh. Giờ sinh quyết định vị trí 12 cung + nhiều sao,
/// nên khi không biết/ước lượng cần cảnh báo độ chính xác cho người dùng.
enum HourConfidence { chinhXac, uocLuong, khongBiet }

extension HourConfidenceLabel on HourConfidence {
  String get label => switch (this) {
        HourConfidence.chinhXac => 'Biết chính xác',
        HourConfidence.uocLuong => 'Ước lượng',
        HourConfidence.khongBiet => 'Không biết',
      };
}

/// Id cố định của hồ sơ CHÍNH CHỦ (bản thân). Người thân dùng id sinh tự động.
const String kSelfId = 'self';

/// Nhãn quan hệ mặc định của chính chủ.
const String kSelfRelation = 'Bản thân';

/// Hồ sơ cá nhân — nền tảng để mọi tính năng phong thủy xoay quanh 1 người.
/// Ngày sinh là DƯƠNG LỊCH (chuyển sang âm lịch nội bộ khi cần can chi/tuổi).
/// Cùng một model dùng cho bản thân lẫn người thân (khác nhau ở [id]/[relation]).
class Profile {
  final String id; // kSelfId cho chính chủ; id sinh tự động cho người thân
  final String relation; // 'Bản thân' / 'Bố' / 'Mẹ' / 'Con'...
  final String name; // '' nếu không nhập
  final DateTime birthDate; // dương lịch
  final Gender gender;
  final int? hourChi; // 0..11 (Tý..Hợi) hoặc null = không rõ
  final HourConfidence hourConf;
  final int? gioPhut; // phút kể từ 00:00 (0..1439) hoặc null = không rõ
  final String? noiSinh; // tên tỉnh trong kNoiSinh hoặc null = không rõ

  const Profile({
    this.id = kSelfId,
    this.relation = kSelfRelation,
    this.name = '',
    required this.birthDate,
    this.gender = Gender.nam,
    this.hourChi,
    this.hourConf = HourConfidence.chinhXac,
    this.gioPhut,
    this.noiSinh,
  });

  bool get isSelf => id == kSelfId;

  Profile copyWith({
    String? id,
    String? relation,
    String? name,
    DateTime? birthDate,
    Gender? gender,
    int? hourChi,
    bool clearHour = false,
    HourConfidence? hourConf,
    int? gioPhut,
    bool clearGioPhut = false,
    String? noiSinh,
    bool clearNoiSinh = false,
  }) =>
      Profile(
        id: id ?? this.id,
        relation: relation ?? this.relation,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        hourChi: clearHour ? null : (hourChi ?? this.hourChi),
        hourConf: hourConf ?? this.hourConf,
        gioPhut: clearGioPhut ? null : (gioPhut ?? this.gioPhut),
        noiSinh: clearNoiSinh ? null : (noiSinh ?? this.noiSinh),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'relation': relation,
        'name': name,
        'birth': birthDate.toIso8601String(),
        'gender': gender.name,
        'hourChi': hourChi,
        'hourConf': hourConf.name,
        'gioPhut': gioPhut,
        'noiSinh': noiSinh,
      };

  factory Profile.fromJson(Map<String, dynamic> j) {
    final d = DateTime.tryParse(j['birth'] as String? ?? '') ??
        DateTime(1990, 1, 1);
    final h = j['hourChi'] as int?;
    final hourChi = (h == null || h < 0) ? null : h;
    var conf = ProfileStore._confFrom(j['hourConf'] as String?) ??
        HourConfidence.khongBiet;
    if (hourChi == null) conf = HourConfidence.khongBiet;
    return Profile(
      id: j['id'] as String? ?? ProfileStore.newId(),
      relation: j['relation'] as String? ?? 'Người thân',
      name: j['name'] as String? ?? '',
      birthDate: d,
      gender: j['gender'] == 'nu' ? Gender.nu : Gender.nam,
      hourChi: hourChi,
      hourConf: conf,
      gioPhut: ProfileStore._gioPhutFrom(j['gioPhut']),
      noiSinh: j['noiSinh'] is String ? j['noiSinh'] as String : null,
    );
  }
}

/// Lưu/đọc hồ sơ. Chính chủ dùng các khoá rời (chia sẻ `birth_date` với
/// biorhythm — không trùng lặp). Người thân lưu dạng JSON list ở khoá riêng.
class ProfileStore {
  static const _kBirth = 'birth_date';
  static const _kName = 'profile_name';
  static const _kGender = 'profile_gender'; // 'nam' / 'nu'
  static const _kHour = 'profile_hour'; // int, -1 = không rõ
  static const _kHourConf = 'profile_hour_conf'; // 'chinhXac'/'uocLuong'/'khongBiet'
  static const _kGioPhut = 'profile_gio_phut'; // int, -1 = không rõ
  static const _kNoiSinh = 'profile_noi_sinh'; // tên tỉnh; bỏ khoá khi không rõ
  static const _kRelatives = 'relatives_json'; // JSON list các người thân

  /// Id mới cho người thân (đủ duy nhất trong phạm vi app).
  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  /// Hồ sơ chính chủ. Trả null nếu chưa có (chưa nhập ngày sinh).
  Future<Profile?> load() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kBirth);
    final d = s == null ? null : DateTime.tryParse(s);
    if (d == null) return null;
    final g = p.getString(_kGender) == 'nu' ? Gender.nu : Gender.nam;
    final h = p.getInt(_kHour);
    final hourChi = (h == null || h < 0) ? null : h;
    // Back-compat: bản cũ không có khoá độ tin cậy → suy từ việc có giờ hay không.
    var conf = _confFrom(p.getString(_kHourConf)) ??
        (hourChi == null ? HourConfidence.khongBiet : HourConfidence.chinhXac);
    // Chuẩn hoá: không có giờ thì luôn là "không biết".
    if (hourChi == null) conf = HourConfidence.khongBiet;
    return Profile(
      id: kSelfId,
      relation: kSelfRelation,
      name: p.getString(_kName) ?? '',
      birthDate: d,
      gender: g,
      hourChi: hourChi,
      hourConf: conf,
      gioPhut: _gioPhutFrom(p.getInt(_kGioPhut)),
      noiSinh: p.getString(_kNoiSinh),
    );
  }

  /// Lưu hồ sơ chính chủ (giữ nguyên các khoá rời để tương thích biorhythm).
  Future<void> save(Profile pr) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kBirth, pr.birthDate.toIso8601String());
    await p.setString(_kName, pr.name);
    await p.setString(_kGender, pr.gender == Gender.nu ? 'nu' : 'nam');
    await p.setInt(_kHour, pr.hourChi ?? -1);
    await p.setString(_kHourConf, pr.hourConf.name);
    await p.setInt(_kGioPhut, pr.gioPhut ?? -1);
    if (pr.noiSinh == null) {
      await p.remove(_kNoiSinh);
    } else {
      await p.setString(_kNoiSinh, pr.noiSinh!);
    }
  }

  /// Danh sách người thân (không gồm chính chủ). Rỗng nếu chưa thêm ai.
  Future<List<Profile>> loadRelatives() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kRelatives);
    if (s == null || s.isEmpty) return [];
    try {
      final raw = jsonDecode(s);
      if (raw is! List) return [];
      return raw
          .whereType<Map>()
          .map((e) => Profile.fromJson(e.cast<String, dynamic>()))
          .toList();
    } catch (_) {
      // JSON hỏng → coi như chưa có người thân (không làm crash màn hình).
      return [];
    }
  }

  /// Tất cả người trong hồ sơ: chính chủ đứng đầu, rồi tới người thân.
  /// Rỗng nếu chưa có chính chủ (các màn sẽ hiện lời mời thêm hồ sơ).
  Future<List<Profile>> loadAll() async {
    final self = await load();
    if (self == null) return [];
    final rel = await loadRelatives();
    return [self, ...rel];
  }

  /// Thêm mới hoặc cập nhật một người thân (khớp theo [Profile.id]).
  Future<void> upsertRelative(Profile r) async {
    final p = await SharedPreferences.getInstance();
    final list = await loadRelatives();
    final i = list.indexWhere((e) => e.id == r.id);
    if (i >= 0) {
      list[i] = r;
    } else {
      list.add(r);
    }
    await p.setString(
        _kRelatives, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  /// Xoá một người thân theo id.
  Future<void> deleteRelative(String id) async {
    final p = await SharedPreferences.getInstance();
    final list = await loadRelatives()
      ..removeWhere((e) => e.id == id);
    await p.setString(
        _kRelatives, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  static int? _gioPhutFrom(Object? v) =>
      (v is int && v >= 0 && v < 1440) ? v : null;

  static HourConfidence? _confFrom(String? s) => switch (s) {
        'chinhXac' => HourConfidence.chinhXac,
        'uocLuong' => HourConfidence.uocLuong,
        'khongBiet' => HourConfidence.khongBiet,
        _ => null,
      };
}
