/// Tổng hợp lá số tử vi (THAM KHẢO): chấm điểm cung, chấm theo chủ đề và
/// tổng kết điểm mạnh/yếu/nghề hợp. Tất cả tính theo QUY TẮC cố định từ trạng
/// thái sao (Miếu/Hãm), Tứ Hóa và cát/sát tinh — KHÔNG ngẫu nhiên.
library;

import 'can_chi.dart';
import 'lunar_calendar.dart';
import 'tu_vi.dart';
import 'tu_vi_dien_giai.dart';
import 'tu_vi_data/bo_sao_data.dart';
import 'tu_vi_data/tong_ket_data.dart';

/// Chấm điểm 1 chủ đề (cung) theo sao.
class ChamChuDe {
  final String ten;
  final String icon;
  final int sao; // 1..5
  final String nhanXet;
  const ChamChuDe(this.ten, this.icon, this.sao, this.nhanXet);
}

/// Tổng kết toàn lá số.
class TongKet {
  final List<String> diemManh;
  final List<String> diemYeu;
  final List<String> ngheHop;
  final String loiKhuyen;
  const TongKet(this.diemManh, this.diemYeu, this.ngheHop, this.loiKhuyen);
}

const Map<String, double> _diemDacTinh = {
  'Miếu': 2.0,
  'Vượng': 1.4,
  'Đắc': 0.8,
  'Bình': 0.0,
  'Hãm': -1.4,
};

const Map<String, double> _diemTuHoa = {
  'Hóa lộc': 1.4,
  'Hóa quyền': 1.0,
  'Hóa khoa': 1.0,
  'Hóa kỵ': -1.4,
};

/// Điểm thô của một cung (càng cao càng nhiều thuận lợi).
double _diemRaw(CungTuVi cung) {
  var d = 0.0;
  for (final s in cung.chinhTinh) {
    d += s.dacTinh != null ? (_diemDacTinh[s.dacTinh] ?? 0.3) : 0.3;
  }
  if (cung.chinhTinh.isEmpty) d -= 0.6; // vô chính diệu
  for (final s in cung.sao.where((s) => s.nhom == NhomSao.tuHoa)) {
    d += _diemTuHoa[s.ten] ?? 0.0;
  }
  final l = luanCung(cung);
  d += (l.saoTot.length.clamp(0, 4)) * 0.4;
  d -= (l.saoXau.length.clamp(0, 4)) * 0.4;
  if (cung.tuan) d -= 0.6;
  if (cung.triet) d -= 0.6;
  return d;
}

/// Quy điểm thô về thang 1..5 sao.
int diemCung(CungTuVi cung) {
  final d = _diemRaw(cung);
  if (d >= 3.0) return 5;
  if (d >= 1.5) return 4;
  if (d >= 0.0) return 3;
  if (d >= -1.5) return 2;
  return 1;
}

/// Chuỗi sao đặc/rỗng, vd 4 → "★★★★☆".
String saoChuoi(int sao) =>
    '★' * sao + '☆' * (5 - sao);

const Map<int, String> _ketLuanMuc = {
  5: 'Đây là một cung rất mạnh — nhiều thuận lợi, biết phát huy sẽ đạt kết '
      'quả tốt.',
  4: 'Cung khá tốt — nhìn chung suôn sẻ, cố gắng thêm sẽ tiến xa.',
  3: 'Cung ở mức trung bình — không quá nổi bật cũng không xấu, cứ làm đều đặn.',
  2: 'Cung hơi yếu — cần thận trọng và kiên trì hơn ở phương diện này.',
  1: 'Cung yếu, nhiều trắc trở — nên cẩn thận, kiên nhẫn và tìm thêm trợ lực.',
};

/// Kết luận ngắn cho một cung (sao + 1 câu).
String ketLuanCung(CungTuVi cung) {
  final sao = diemCung(cung);
  return '${saoChuoi(sao)}  ($sao/5)\n${_ketLuanMuc[sao]}';
}

CungTuVi _cung(LaSoTuVi la, String ten) =>
    la.cung.firstWhere((c) => c.tenCung == ten);

const Map<String, String> _nhanXetChuDe = {
  // theo "ten|muc" 1..5
  'Tình duyên|cao': 'Đường tình cảm thuận, dễ gặp người hợp và gắn bó bền.',
  'Tình duyên|tb': 'Tình cảm ổn, cần vun đắp và lắng nghe nhau nhiều hơn.',
  'Tình duyên|thap': 'Tình duyên dễ trắc trở, nên kiên nhẫn, tránh nóng vội.',
  'Tài chính|cao': 'Khả năng kiếm và giữ tiền tốt, dễ tích lũy.',
  'Tài chính|tb': 'Tiền bạc đủ dùng, nên có kế hoạch chi tiêu rõ ràng.',
  'Tài chính|thap': 'Tài chính dễ hao hụt, cần tiết kiệm và tránh đầu tư liều.',
  'Sự nghiệp|cao': 'Công danh hanh thông, có cơ hội thăng tiến.',
  'Sự nghiệp|tb': 'Sự nghiệp ổn định, tiến từng bước, chớ nóng vội.',
  'Sự nghiệp|thap': 'Đường công danh nhiều thử thách, cần bền chí và học hỏi.',
  'Sức khỏe|cao': 'Thể trạng tốt, ít bệnh vặt; duy trì lối sống lành mạnh.',
  'Sức khỏe|tb': 'Sức khỏe bình thường, chú ý nghỉ ngơi điều độ.',
  'Sức khỏe|thap': 'Cần quan tâm sức khỏe hơn, khám định kỳ và giữ gìn.',
  'Con cái|cao': 'Đường con cái tốt đẹp, con ngoan và có duyên với con.',
  'Con cái|tb': 'Chuyện con cái bình thường, cần dành thời gian quan tâm.',
  'Con cái|thap': 'Đường con cái dễ vất vả, nên kiên nhẫn và chăm lo nhiều hơn.',
};

String _mucKey(int sao) => sao >= 4 ? 'cao' : (sao >= 3 ? 'tb' : 'thap');

/// Chấm 5 chủ đề từ cung tương ứng.
List<ChamChuDe> chamChuDe(LaSoTuVi la) {
  const map = [
    ['Tình duyên', '❤️', 'Phu thê'],
    ['Tài chính', '💰', 'Tài bạch'],
    ['Sự nghiệp', '💼', 'Quan lộc'],
    ['Sức khỏe', '🌿', 'Tật ách'],
    ['Con cái', '👶', 'Tử tức'],
  ];
  return [
    for (final m in map)
      () {
        final sao = diemCung(_cung(la, m[2]));
        final nx = _nhanXetChuDe['${m[0]}|${_mucKey(sao)}'] ?? '';
        return ChamChuDe(m[0], m[1], sao, nx);
      }(),
  ];
}

List<String> _gopChinhTinh(CungTuVi cung, Map<String, List<String>> nguon) {
  final out = <String>[];
  for (final s in cung.chinhTinh) {
    for (final v in nguon[s.ten] ?? const <String>[]) {
      if (!out.contains(v)) out.add(v);
    }
  }
  return out;
}

/// Tổng kết: điểm mạnh/yếu (theo Mệnh), nghề hợp (theo Quan lộc), lời khuyên
/// (theo chủ đề yếu nhất).
TongKet tongKet(LaSoTuVi la) {
  final menh = la.cungMenh;
  final manh = _gopChinhTinh(menh, menhDiemManh);
  final yeu = _gopChinhTinh(menh, menhDiemYeu);
  if (menh.chinhTinh.isEmpty) {
    manh.addAll(['Linh hoạt, đa diện', 'Dễ thích nghi']);
    yeu.add('Cần điểm tựa và mục tiêu rõ ràng');
  }

  // Nghề: ưu tiên Quan lộc, thiếu thì lấy Mệnh.
  final quan = _cung(la, 'Quan lộc');
  var nghe = _gopChinhTinh(quan, ngheTheoChinhTinh);
  if (nghe.isEmpty) nghe = _gopChinhTinh(menh, ngheTheoChinhTinh);
  if (nghe.isEmpty) nghe = ['Nghề tự do, linh hoạt'];

  // Lời khuyên theo chủ đề điểm thấp nhất.
  final cd = chamChuDe(la);
  cd.sort((a, b) => a.sao.compareTo(b.sao));
  final yeuNhat = cd.first;
  final loiKhuyen = yeuNhat.sao <= 3
      ? 'Nên dành thêm quan tâm cho ${yeuNhat.ten.toLowerCase()}: '
          '${yeuNhat.nhanXet}'
      : 'Lá số nhìn chung cân đối — hãy phát huy thế mạnh và giữ sự đều đặn.';

  return TongKet(manh, yeu, nghe, loiKhuyen);
}

// ---------------------------------------------------------------------------
// Bộ sao · Cách cục · Xung chiếu · Vận hạn (Chặng 3)
// ---------------------------------------------------------------------------

/// Diễn giải bộ sao khi cung có đúng 2 chính tinh đi cặp; null nếu không.
String? boSaoCung(CungTuVi cung) {
  final ct = cung.chinhTinh;
  if (ct.length != 2) return null;
  final a = ct[0].ten, b = ct[1].ten;
  return boSaoCap['$a|$b'] ?? boSaoCap['$b|$a'];
}

String? _nhomCachCuc(String tenSao) {
  for (final e in cachCucThanhVien.entries) {
    if (e.value.contains(tenSao)) return e.key;
  }
  return null;
}

/// Cách cục theo chính tinh Mệnh (Mệnh VCD thì mượn Thiên di); '' nếu không rõ.
String cachCucMenh(LaSoTuVi la) {
  var ct = la.cungMenh.chinhTinh;
  if (ct.isEmpty) {
    final di = la.cung.firstWhere((c) => c.tenCung == 'Thiên di',
        orElse: () => la.cungMenh);
    ct = di.chinhTinh;
  }
  for (final s in ct) {
    final nhom = _nhomCachCuc(s.ten);
    if (nhom != null) return '$nhom — ${cachCucYNghia[nhom]}';
  }
  return '';
}

/// Tên cung đối diện (xung chiếu).
String doiCungCua(String tenCung) => doiCung[tenCung] ?? '';

/// Vận hạn của một năm (đại hạn 10 năm + tiểu hạn năm).
class VanHan {
  final int tuoiMu;
  final String namCanChi;
  final String daiHanCung;
  final int daiHanTu;
  final String tieuHanCung;
  final String nhanXet;
  const VanHan(this.tuoiMu, this.namCanChi, this.daiHanCung, this.daiHanTu,
      this.tieuHanCung, this.nhanXet);
}

/// Vận hạn của năm chứa [now] (mặc định hôm nay).
VanHan vanHanNam(LaSoTuVi la, {DateTime? now}) {
  final d = now ?? DateTime.now();
  final namAm = solarToLunar(d.day, d.month, d.year).year;
  final namCanChi = canChiOfYear(namAm);
  final tuoiMu = namAm - la.lunar.year + 1;
  final chiNam = diaChi[(namAm + 8) % 12];

  final dh = la.cung.firstWhere(
      (c) => tuoiMu >= c.daiHanTu && tuoiMu <= c.daiHanTu + 9,
      orElse: () => la.cungMenh);
  final th = la.cung.firstWhere((c) => c.tieuHanChi == chiNam,
      orElse: () => la.cungMenh);

  final dhSao = diemCung(dh);
  final thSao = diemCung(th);
  final nhanXet =
      'Đại vận đang ở cung ${dh.tenCung} (${saoChuoi(dhSao)}): '
      '${_ketLuanMuc[dhSao]} '
      'Vận năm $namCanChi ghé cung ${th.tenCung} (${saoChuoi(thSao)}): '
      '${_ketLuanMuc[thSao]}';

  return VanHan(tuoiMu, namCanChi, dh.tenCung, dh.daiHanTu, th.tenCung, nhanXet);
}
