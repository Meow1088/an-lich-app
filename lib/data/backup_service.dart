import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Sao lưu / khôi phục toàn bộ dữ liệu app (offline, không cloud).
/// Gói các khoá SharedPreferences kèm kiểu để khôi phục đúng.
class BackupService {
  /// Các khoá dữ liệu người dùng được sao lưu.
  static const _keys = <String>[
    'birth_date',
    'profile_name',
    'profile_gender',
    'profile_hour',
    'profile_hour_conf',
    'profile_gio_phut',
    'profile_noi_sinh',
    'ty_muon_sang_hom_sau',
    'reminders',
    'theme_mode',
    'light_theme_id',
    'text_scale',
    'glass_effect',
    'bg_enabled',
    'bg_opacity',
  ];

  Future<String> exportJson() async {
    final p = await SharedPreferences.getInstance();
    final data = <String, dynamic>{};
    for (final k in _keys) {
      if (!p.containsKey(k)) continue;
      final v = p.get(k);
      if (v is List) {
        data[k] = {'t': 'list', 'v': v};
      } else if (v is bool) {
        data[k] = {'t': 'bool', 'v': v};
      } else if (v is int) {
        data[k] = {'t': 'int', 'v': v};
      } else if (v is double) {
        data[k] = {'t': 'double', 'v': v};
      } else {
        data[k] = {'t': 'str', 'v': v};
      }
    }
    return const JsonEncoder.withIndent('  ').convert({
      'app': 'An Lich',
      'v': 1,
      'ts': DateTime.now().toIso8601String(),
      'data': data,
    });
  }

  /// Sửa chuỗi tiếng Việt bị "double-encode" (UTF-8 bị đọc nhầm Latin-1 rồi
  /// lưu lại ở app trung gian) — vd "Nguyễn" thành "Nguyá»…n". Nhận diện:
  /// mọi ký tự ≤ 0xFF và có ít nhất 1 byte-tiếp-nối UTF-8 (0x80–0xBF);
  /// giải mã lại latin1→utf8, chỉ dùng kết quả khi giải mã hợp lệ.
  /// Chuỗi tiếng Việt bình thường có ký tự > 0xFF (vd ễ, Đ) nên không bị đổi.
  static String fixMojibake(String s) {
    if (s.isEmpty) return s;
    var hasContinuationByte = false;
    for (final c in s.codeUnits) {
      if (c > 0xFF) return s; // ngoài Latin-1 → không phải mojibake
      if (c >= 0x80 && c <= 0xBF) hasContinuationByte = true;
    }
    if (!hasContinuationByte) return s;
    try {
      return utf8.decode(latin1.encode(s));
    } on FormatException {
      return s; // không phải UTF-8 hợp lệ → giữ nguyên
    }
  }

  /// Khôi phục từ chuỗi JSON. Trả số mục đã khôi phục. Ném lỗi nếu định dạng sai.
  Future<int> importJson(String raw) async {
    final m = jsonDecode(raw) as Map<String, dynamic>;
    final data = m['data'];
    if (data is! Map) {
      throw const FormatException('Tệp sao lưu không hợp lệ (thiếu "data").');
    }
    final p = await SharedPreferences.getInstance();
    var n = 0;
    for (final e in data.entries) {
      final entry = e.value as Map;
      final t = entry['t'];
      final v = entry['v'];
      switch (t) {
        case 'list':
          await p.setStringList(
              e.key, (v as List).cast<String>().map(fixMojibake).toList());
        case 'bool':
          await p.setBool(e.key, v as bool);
        case 'int':
          await p.setInt(e.key, v as int);
        case 'double':
          await p.setDouble(e.key, (v as num).toDouble());
        default:
          await p.setString(e.key, fixMojibake(v as String));
      }
      n++;
    }
    return n;
  }
}
