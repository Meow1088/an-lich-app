/// Logic LUẬN GIẢI tử vi (tham khảo) — tách dữ liệu sang `tu_vi_data/`.
///
/// Quy trình: engine an sao (`tu_vi.dart`) → [luanCung] gom thành mô hình có
/// cấu trúc [CungLuan] → render theo [CheDoXem] (Cơ bản / Chuyên sâu).
///
/// Nội dung theo tử vi đẩu số cổ truyền (phổ biến), mang tính THAM KHẢO /
/// tín ngưỡng, không phải khẳng định khoa học. Có nhiều dị bản giữa các phái.
library;

import 'tu_vi.dart';
import 'luan_tuoi.dart';
import 'tu_vi_data/chinh_tinh_data.dart';
import 'tu_vi_data/co_ban_data.dart';
import 'tu_vi_data/cung_data.dart';
import 'tu_vi_data/phu_tinh_data.dart';
import 'tu_vi_data/tong_ket_data.dart';
import 'tu_vi_data/tu_hoa_data.dart';

// Re-export dữ liệu để nơi gọi (UI, test) chỉ cần import 1 file này.
export 'tu_vi_data/chinh_tinh_data.dart';
export 'tu_vi_data/co_ban_data.dart';
export 'tu_vi_data/cung_data.dart';
export 'tu_vi_data/phu_tinh_data.dart';
export 'tu_vi_data/tu_hoa_data.dart';

/// Hai chế độ trình bày diễn giải.
/// - [coBan]: ngôn ngữ đời thường, hạn chế thuật ngữ (mặc định người dùng phổ thông).
/// - [chuyenSau]: đầy đủ thuật ngữ tử vi (Miếu/Hãm, Tuần/Triệt…) cho người am hiểu.
enum CheDoXem { coBan, chuyenSau }

/// Một dòng luận cho 1 chính tinh trong cung.
class LuanChinhTinh {
  final String ten;
  final String? dacTinh; // Miếu/Vượng/Đắc/Bình/Hãm (có thể null)
  final String dienGiai; // lớp sâu theo cung, fallback tính chất chung
  const LuanChinhTinh(this.ten, this.dacTinh, this.dienGiai);
}

/// Một phụ/sát tinh kèm ý nghĩa ngắn.
class LuanSaoPhu {
  final String ten;
  final String yNghia;
  const LuanSaoPhu(this.ten, this.yNghia);
}

/// Mô hình luận giải có cấu trúc cho một cung — để renderer và các lớp nội dung
/// sau (kết luận, chấm chủ đề…) bám vào thay vì nối chuỗi rời rạc.
class CungLuan {
  final String tenCung;
  final String? yNghia;
  final String chi;
  final String canChi;
  final bool voChinhDieu;
  final List<LuanChinhTinh> chinhTinh;
  final List<String> tuHoa; // text đã diễn giải
  final List<LuanSaoPhu> saoTot; // phụ tinh hỗ trợ (kèm ý nghĩa)
  final List<LuanSaoPhu> saoXau; // sát/hung tinh cần lưu ý (kèm ý nghĩa)
  final bool tuan;
  final bool triet;

  const CungLuan({
    required this.tenCung,
    required this.yNghia,
    required this.chi,
    required this.canChi,
    required this.voChinhDieu,
    required this.chinhTinh,
    required this.tuHoa,
    required this.saoTot,
    required this.saoXau,
    required this.tuan,
    required this.triet,
  });
}

/// Rule engine nhỏ: gom một [CungTuVi] (từ engine an sao) thành [CungLuan].
CungLuan luanCung(CungTuVi cung) {
  final chinhTinh = [
    for (final s in cung.chinhTinh)
      LuanChinhTinh(
        s.ten,
        s.dacTinh,
        // Ưu tiên lớp diễn giải sâu theo cung; chưa có thì dùng tính chất chung.
        dienGiaiSauChinhTinh(cung.tenCung, s.ten) ??
            chinhTinhTinhChat[s.ten] ??
            '',
      ),
  ];
  final tuHoa = [
    for (final s in cung.sao.where((s) => s.nhom == NhomSao.tuHoa))
      tuHoaYNghia[s.ten] ?? s.ten,
  ];

  // Phụ/sát tinh có dữ liệu ý nghĩa → tách thành nhóm hỗ trợ / cần lưu ý.
  // (Chính tinh và Tứ Hóa đã luận riêng nên không nằm trong bảng phụ tinh.)
  final saoTot = <LuanSaoPhu>[];
  final saoXau = <LuanSaoPhu>[];
  for (final s in cung.sao) {
    final yn = yNghiaPhuTinh(s.ten);
    if (yn == null) continue;
    (laSaoCanLuuY(s.ten) ? saoXau : saoTot).add(LuanSaoPhu(s.ten, yn));
  }

  return CungLuan(
    tenCung: cung.tenCung,
    yNghia: yNghiaCung[cung.tenCung],
    chi: cung.chi,
    canChi: cung.canChi,
    voChinhDieu: chinhTinh.isEmpty,
    chinhTinh: chinhTinh,
    tuHoa: tuHoa,
    saoTot: saoTot,
    saoXau: saoXau,
    tuan: cung.tuan,
    triet: cung.triet,
  );
}

/// Diễn giải cho một cung bất kỳ (dùng trong bottom sheet).
/// Mặc định [CheDoXem.chuyenSau] để giữ tương thích nơi gọi cũ.
String dienGiaiCung(CungTuVi cung, {CheDoXem mode = CheDoXem.chuyenSau}) {
  final l = luanCung(cung);
  return mode == CheDoXem.coBan ? _renderCoBan(l) : _renderChuyenSau(l);
}

/// Nối danh sách thành liệt kê tiếng Việt: "A", "A và B", "A, B và C".
String _lietKe(List<String> xs) {
  if (xs.isEmpty) return '';
  if (xs.length == 1) return xs.first;
  return '${xs.sublist(0, xs.length - 1).join(', ')} và ${xs.last}';
}

/// Viết hoa chữ cái đầu (các lớp diễn giải gốc là mảnh liệt kê nên hay bắt đầu
/// bằng chữ thường — hoa hóa để đứng thành câu văn xuôi cho gọn gàng).
String _hoaCau(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

/// Cụm trạng thái sao dạng văn xuôi, vd " (thế miếu — rất mạnh)".
String _theSao(String? dacTinh) {
  if (dacTinh == null) return '';
  final gloss = dacTinhNghia[dacTinh];
  final low = dacTinh.toLowerCase();
  return gloss != null ? ' (thế $low — $gloss)' : ' (thế $low)';
}

/// Thân bài văn xuôi cho một cung (Chuyên sâu): chính tinh → Tứ Hóa → phụ/sát
/// tinh → Tuần/Triệt. Giữ NGUYÊN VĂN các lớp diễn giải để mạch đọc liền lạc mà
/// nội dung không đổi so với bản liệt kê cũ.
String _proseCungBody(CungLuan l) {
  final sb = StringBuffer();

  if (l.voChinhDieu) {
    sb.write('Đây là cung vô chính diệu — không có chính tinh tọa thủ — nên cần '
        'mượn ảnh hưởng của cung đối diện để luận; các phương diện của cung '
        'thường nhiều mặt, linh hoạt, dễ thích nghi nhưng cần một điểm tựa rõ '
        'ràng. ');
  } else {
    final ten = [for (final s in l.chinhTinh) '${s.ten}${_theSao(s.dacTinh)}'];
    sb.write('Tại đây có ${_lietKe(ten)} tọa thủ. ');
    for (final s in l.chinhTinh) {
      sb.write('${_hoaCau(s.dienGiai)} ');
    }
  }

  if (l.tuHoa.isNotEmpty) {
    sb.write('Về Tứ Hóa, ${l.tuHoa.join(' ')} ');
  }
  if (l.saoTot.isNotEmpty) {
    final xs = [for (final s in l.saoTot) '${s.ten} (${s.yNghia})'];
    sb.write('Hỗ trợ cho cung có ${_lietKe(xs)}. ');
  }
  if (l.saoXau.isNotEmpty) {
    final xs = [for (final s in l.saoXau) '${s.ten} (${s.yNghia})'];
    sb.write('Bên cạnh đó cần lưu ý ${_lietKe(xs)}. ');
  }
  if (l.tuan || l.triet) {
    final marks = [if (l.tuan) 'Tuần', if (l.triet) 'Triệt'].join(' và ');
    sb.write('Ngoài ra cung bị $marks án ngữ nên sức ảnh hưởng phần nào bị giảm '
        'hoặc ngăn trở, cần cân nhắc kỹ theo từng sao. ');
  }
  return sb.toString();
}

String _renderChuyenSau(CungLuan l) {
  final sb = StringBuffer();
  sb.write('Cung ${l.tenCung} an tại ${l.chi} (${l.canChi}). ');
  if (l.yNghia != null) sb.write('${l.yNghia} ');
  sb.write(_proseCungBody(l));
  return sb.toString().trim();
}

String _renderCoBan(CungLuan l) {
  final sb = StringBuffer();
  if (l.yNghia != null) sb.writeln('${l.tenCung} — ${l.yNghia}');

  if (l.voChinhDieu) {
    sb.writeln('\nCung này không có sao chính, nên cần xem thêm các cung liên '
        'quan để luận rõ hơn.');
  } else {
    for (final s in l.chinhTinh) {
      final tt = s.dacTinh != null ? ' (${trangThaiCoBan(s.dacTinh!)})' : '';
      sb.writeln('\n⭐ ${s.ten}$tt');
      sb.writeln(s.dienGiai);
    }
  }

  if (l.tuHoa.isNotEmpty) {
    sb.writeln('');
    for (final t in l.tuHoa) {
      sb.writeln('• $t');
    }
  }

  if (l.saoTot.isNotEmpty) {
    sb.writeln('\n👍 Điểm hỗ trợ:');
    for (final s in l.saoTot) {
      sb.writeln('• ${s.ten}: ${s.yNghia}');
    }
  }
  if (l.saoXau.isNotEmpty) {
    sb.writeln('\n⚠ Cần lưu ý:');
    for (final s in l.saoXau) {
      sb.writeln('• ${s.ten}: ${s.yNghia}');
    }
  }

  if (l.tuan || l.triet) {
    sb.writeln('\nMột số việc ở phương diện này có thể đến chậm hơn người khác; '
        'kiên trì thì vẫn đạt kết quả tốt.');
  }
  return sb.toString().trim();
}

/// Diễn giải tổng cho cung Mệnh (header card).
/// Mặc định [CheDoXem.chuyenSau] để giữ tương thích nơi gọi cũ.
String dienGiaiMenh(LaSoTuVi la, {CheDoXem mode = CheDoXem.chuyenSau}) {
  // Chế độ Cơ bản: trình bày như một phân tích tính cách, không dùng thuật ngữ.
  if (mode == CheDoXem.coBan) return _renderMenhCoBan(la);

  // Chế độ Chuyên sâu: văn xuôi liền mạch — mở bằng bản mệnh tổng quan (con
  // giáp + nạp âm) rồi luận cung Mệnh, giọng người diễn giải (xưng "bạn").
  final t = luanTheoTuoi(la.lunar.year);
  final menh = la.cungMenh;
  final l = luanCung(menh);
  final sb = StringBuffer();

  sb.write('Bạn sinh năm ${t.canChiNam}, tuổi ${t.conVat}, bản mệnh '
      '${t.banMenhTen} (hành ${t.banMenh}). ${t.banMenhYNghia} ');
  sb.write('Cung Mệnh an tại ${menh.chi} (${menh.canChi}), ${la.amDuongMenh}, '
      '${la.cucTen}. ${cucYNghia(la.cucSo)} ');
  sb.write(_proseCungBody(l));
  return sb.toString().trim();
}

/// Render cung Mệnh theo chế độ Cơ bản: chia thành các mục dễ đọc
/// (Tính cách / Điểm mạnh / Điều cần lưu ý / Công việc / Tình cảm), giọng đời
/// thường như một bản phân tích, hạn chế tối đa thuật ngữ tử vi.
String _renderMenhCoBan(LaSoTuVi la) {
  final ct = la.cungMenh.chinhTinh;
  final sb = StringBuffer();

  if (ct.isEmpty) {
    sb.writeln('⭐ Tính cách');
    sb.writeln('Cung Mệnh của bạn không có sao chính, nên tính cách khá nhiều '
        'mặt và dễ thích nghi theo hoàn cảnh. Bạn linh hoạt, học nhanh, nhưng '
        'sẽ vững vàng hơn khi có mục tiêu và điểm tựa rõ ràng.');
    sb.writeln('\n💼 Công việc phù hợp');
    sb.writeln('Nghề tự do, linh hoạt · Việc cần khả năng thích nghi');
    return sb.toString().trim();
  }

  final tinhCach = <String>[];
  final tinhCam = <String>[];
  for (final s in ct) {
    final m = menhCoBan[s.ten];
    if (m == null) continue;
    tinhCach.add(m.tinhCach);
    tinhCam.add(m.tinhCam);
  }

  sb.writeln('⭐ Tính cách');
  sb.writeln(tinhCach.isEmpty
      ? 'Bạn có cá tính riêng, kết hợp nhiều nét khác nhau.'
      : tinhCach.join('\n\n'));

  final manh = _union([for (final s in ct) ...?menhDiemManh[s.ten]]);
  if (manh.isNotEmpty) {
    sb.writeln('\n👍 Điểm mạnh');
    for (final x in manh) {
      sb.writeln('• $x');
    }
  }

  final yeu = _union([for (final s in ct) ...?menhDiemYeu[s.ten]]);
  if (yeu.isNotEmpty) {
    sb.writeln('\n⚠ Điều cần lưu ý');
    for (final x in yeu) {
      sb.writeln('• $x');
    }
  }

  final nghe = _union([for (final s in ct) ...?ngheTheoChinhTinh[s.ten]]);
  if (nghe.isNotEmpty) {
    sb.writeln('\n💼 Công việc phù hợp');
    sb.writeln(nghe.join(' · '));
  }

  if (tinhCam.isNotEmpty) {
    sb.writeln('\n❤️ Trong tình cảm');
    sb.writeln(tinhCam.join(' '));
  }

  return sb.toString().trim();
}

/// Gộp danh sách bỏ trùng, giữ thứ tự xuất hiện.
List<String> _union(List<String> xs) {
  final out = <String>[];
  for (final x in xs) {
    if (!out.contains(x)) out.add(x);
  }
  return out;
}
