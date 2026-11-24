/// "Luận theo tuổi" — chế độ 📖 Dễ hiểu, CHỈ cần NĂM sinh (không cần giờ, không
/// lập lá số). Gộp 3 yếu tố từ năm sinh: con giáp (chi năm), bản mệnh (nạp âm
/// ngũ hành) và Tứ Hóa của năm. Nội dung dân gian phổ biến — mang tính THAM
/// KHẢO / tín ngưỡng, có nhiều dị bản.
library;

import 'can_chi.dart' show canChiOfYear, napAmOfYear;
import 'tu_vi.dart' show canNamCuaNam, chiNamCuaNam, tuHoaCuaCanNam;
import 'tu_vi_data/tuoi_data.dart';

/// Một sao mang Tứ Hóa của năm sinh, kèm diễn giải đời thường.
class LuanHoa {
  final String sao; // sao được hóa, vd "Tham lang"
  final String linhVuc; // lĩnh vực liên quan, vd "giao tế, đam mê"
  final String hoa; // "Hóa lộc" | "Hóa quyền" | "Hóa khoa" | "Hóa kỵ"
  final String yNghia; // diễn giải đời thường
  final bool tot; // true = trợ lực; false = cần lưu ý (Hóa kỵ)
  const LuanHoa({
    required this.sao,
    required this.linhVuc,
    required this.hoa,
    required this.yNghia,
    required this.tot,
  });
}

/// Kết quả luận theo tuổi (thuần dữ liệu, không phụ thuộc UI).
class LuanTuoi {
  final int namSinh; // năm âm lịch
  final String canChiNam; // vd "Mậu Thìn"
  final String conVat; // con giáp, vd "Rồng"
  final String tinhCach; // tính cách con giáp
  final String banMenh; // ngũ hành nạp âm: Kim/Mộc/Thủy/Hỏa/Thổ
  final String banMenhTen; // tên nạp âm đầy đủ, vd "Đại Lâm Mộc"
  final String banMenhYNghia; // ý nghĩa bản mệnh
  final List<LuanHoa> tuHoa; // 4 Hóa của năm sinh
  final String disclaimer;
  const LuanTuoi({
    required this.namSinh,
    required this.canChiNam,
    required this.conVat,
    required this.tinhCach,
    required this.banMenh,
    required this.banMenhTen,
    required this.banMenhYNghia,
    required this.tuHoa,
    required this.disclaimer,
  });
}

const String _disclaimer =
    'Nội dung luận theo con giáp, bản mệnh (nạp âm) và Tứ Hóa của năm sinh — '
    'chỉ cần năm sinh, không cần giờ. Đây là kiến thức dân gian mang tính '
    'THAM KHẢO, không phải khẳng định khoa học.';

/// Luận theo tuổi từ NĂM âm lịch (vd 1988). Không cần giờ sinh.
LuanTuoi luanTheoTuoi(int lunarYear) {
  final chiN = chiNamCuaNam(lunarYear); // 1..12 (Tý=1)
  final canN = canNamCuaNam(lunarYear); // 1..10 (Giáp=1)
  final napAm = napAmOfYear(lunarYear);

  final hoaList = [
    for (final h in tuHoaCuaCanNam(canN))
      LuanHoa(
        sao: h.ten,
        linhVuc: saoTuKhoa[h.ten] ?? '',
        hoa: h.hoa,
        yNghia: yNghiaHoa[h.hoa] ?? '',
        tot: hoaLaTot(h.hoa),
      ),
  ];

  return LuanTuoi(
    namSinh: lunarYear,
    canChiNam: canChiOfYear(lunarYear),
    conVat: conGiapConVat[chiN - 1],
    tinhCach: conGiapTinhCach[chiN - 1],
    banMenh: napAm.element,
    banMenhTen: napAm.name,
    banMenhYNghia: nguHanhBanMenh[napAm.element] ?? '',
    tuHoa: hoaList,
    disclaimer: _disclaimer,
  );
}

/// Trình bày [LuanTuoi] thành các đoạn văn xuôi (giọng người diễn giải, xưng
/// "bạn"). Trả về chuỗi có các đoạn cách nhau bằng dòng trống. KHÔNG kèm
/// disclaimer (UI hiển thị riêng).
String luanTuoiVanXuoi(LuanTuoi r) {
  final doan = <String>[];

  doan.add('Bạn tuổi ${r.conVat}, sinh năm ${r.canChiNam}. ${r.tinhCach}');

  doan.add('Về bản mệnh, bạn thuộc ${r.banMenhTen} (hành ${r.banMenh}). '
      '${r.banMenhYNghia}');

  final sb = StringBuffer('Xét theo năm sinh, có bốn nguồn ảnh hưởng đáng chú ý. ');
  for (final h in r.tuHoa) {
    final linh = h.linhVuc.isNotEmpty ? ' (gắn với ${h.linhVuc})' : '';
    if (h.tot) {
      sb.write('${h.sao}$linh mang ${h.hoa}: ${h.yNghia}. ');
    } else {
      sb.write('Riêng ${h.sao}$linh mang ${h.hoa}, ${h.yNghia}. ');
    }
  }
  doan.add(sb.toString().trim());

  return doan.join('\n\n');
}
