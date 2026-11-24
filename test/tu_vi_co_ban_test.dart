import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;
import 'package:lich_am/core/tu_vi_dien_giai.dart';

/// Thuật ngữ chuyên ngành KHÔNG được xuất hiện trong chế độ Cơ bản
/// (người dùng phổ thông phải đọc hiểu ngay — theo góp ý user).
const _jargon = [
  'Miếu', 'Vượng', 'Hãm', 'Tả Hữu', 'Xương Khúc', 'đắc địa', 'hãm địa',
  'Tuần', 'Triệt', 'Vô chính diệu', 'tọa', 'đế tinh', 'ám tinh',
  'chính tài tinh', 'Tứ Hóa', 'tam hợp',
];

void _expectNoJargon(String text, String where) {
  for (final j in _jargon) {
    expect(text.contains(j), isFalse, reason: '$where còn thuật ngữ "$j"');
  }
}

void main() {
  group('menhCoBan (dữ liệu Cơ bản)', () {
    test('đủ 14 chính tinh, mỗi mục không rỗng', () {
      for (final sao in chinhTinhTinhChat.keys) {
        final m = menhCoBan[sao];
        expect(m, isNotNull, reason: 'Thiếu Cơ bản cho "$sao"');
        expect(m!.tinhCach.trim(), isNotEmpty);
        expect(m.tinhCam.trim(), isNotEmpty);
      }
      expect(menhCoBan.length, 14);
    });

    test('không dùng thuật ngữ chuyên ngành', () {
      for (final e in menhCoBan.entries) {
        _expectNoJargon(e.value.tinhCach, 'Tính cách ${e.key}');
        _expectNoJargon(e.value.tinhCam, 'Tình cảm ${e.key}');
      }
    });
  });

  group('dienGiaiMenh — chế độ Cơ bản', () {
    // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
    final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);

    test('có các mục AI-style và không rò thuật ngữ', () {
      final out = dienGiaiMenh(la, mode: CheDoXem.coBan);
      expect(out.contains('⭐ Tính cách'), isTrue);
      expect(out.contains('💼 Công việc phù hợp'), isTrue);
      _expectNoJargon(out, 'dienGiaiMenh Cơ bản');
    });

    test('chế độ Chuyên sâu vẫn giữ thuật ngữ (không bị đổi nhầm)', () {
      final out = dienGiaiMenh(la, mode: CheDoXem.chuyenSau);
      expect(out.contains('Mệnh an tại'), isTrue);
    });
  });
}
