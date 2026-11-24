/// Tử Vi Đẩu Số — an sao 12 cung (offline, rule-based).
///
/// Thuật toán PORT trung thành từ phần mềm an sao mã nguồn mở
/// `doanguyen/lasotuvi` (MIT) — đã đối chiếu khớp tuyệt đối nhiều lá số chuẩn
/// (xem test/tu_vi_test.dart). KHÔNG tự chế công thức.
///
/// Quy ước nội bộ: chỉ số 1-based để khớp reference.
///   cung 1..12 = Tý, Sửu, Dần, ... , Hợi
///   can 1..10 = Giáp..Quý ; chi 1..12 = Tý..Hợi ; giờ 1..12 = Tý..Hợi
///   giới tính: +1 = Nam, -1 = Nữ
///
/// Nội dung an sao là TÍN NGƯỠNG / THAM KHẢO, không phải khẳng định khoa học.
library;

import 'lunar_calendar.dart';
import 'can_chi.dart' show thienCan, diaChi;
import '../data/profile_store.dart' show Gender;

// ----------------------------------------------------------------------------
// Danh mục sao (id -> tên, ngũ hành, loại). Loại: 1=chính tinh, <10 sao tốt,
// >10 sao xấu (theo reference). Sinh từ reference, KHÔNG sửa tay.
// ----------------------------------------------------------------------------
class _S {
  final String ten;
  final String nguHanh; // K/M/T/H/O
  final int loai;
  const _S(this.ten, this.nguHanh, this.loai);
}

const Map<int, _S> _catalog = {
  1: _S('Tử vi', 'O', 1),
  2: _S('Liêm trinh', 'H', 1),
  3: _S('Thiên đồng', 'T', 1),
  4: _S('Vũ khúc', 'K', 1),
  5: _S('Thái Dương', 'H', 1),
  6: _S('Thiên cơ', 'M', 1),
  7: _S('Thiên phủ', 'O', 1),
  8: _S('Thái âm', 'T', 1),
  9: _S('Tham lang', 'T', 1),
  10: _S('Cự môn', 'T', 1),
  11: _S('Thiên tướng', 'T', 1),
  12: _S('Thiên lương', 'M', 1),
  13: _S('Thất sát', 'K', 1),
  14: _S('Phá quân', 'T', 1),
  15: _S('Thái tuế', 'H', 15),
  16: _S('Thiếu dương', 'H', 5),
  17: _S('Tang môn', 'M', 12),
  18: _S('Thiếu âm', 'T', 5),
  19: _S('Quan phù', 'H', 12),
  20: _S('Tử phù', 'K', 12),
  21: _S('Tuế phá', 'H', 12),
  22: _S('Long đức', 'T', 5),
  23: _S('Bạch hổ', 'K', 12),
  24: _S('Phúc đức', 'O', 5),
  25: _S('Điếu khách', 'H', 12),
  26: _S('Trực phù', 'K', 16),
  27: _S('Lộc tồn', 'O', 3),
  28: _S('Lực sĩ', 'H', 2),
  29: _S('Thanh long', 'T', 5),
  30: _S('Tiểu hao', 'H', 12),
  31: _S('Tướng quân', 'M', 4),
  32: _S('Tấu thư', 'K', 3),
  33: _S('Phi liêm', 'H', 2),
  34: _S('Hỷ thần', 'H', 5),
  35: _S('Bệnh phù', 'O', 12),
  36: _S('Đại hao', 'H', 12),
  37: _S('Phục binh', 'H', 13),
  38: _S('Quan phù', 'H', 12),
  39: _S('Tràng sinh', 'T', 5),
  40: _S('Mộc dục', 'T', 14),
  41: _S('Quan đới', 'K', 4),
  42: _S('Lâm quan', 'K', 7),
  43: _S('Đế vượng', 'K', 5),
  44: _S('Suy', 'T', 12),
  45: _S('Bệnh', 'H', 12),
  46: _S('Tử', 'H', 12),
  47: _S('Mộ', 'O', 2),
  48: _S('Tuyệt', 'O', 12),
  49: _S('Thai', 'O', 14),
  50: _S('Dưỡng', 'M', 2),
  51: _S('Đà la', 'K', 11),
  52: _S('Kình dương', 'K', 11),
  53: _S('Địa không', 'H', 11),
  54: _S('Địa kiếp', 'H', 11),
  55: _S('Linh tinh', 'H', 11),
  56: _S('Hỏa tinh', 'H', 11),
  57: _S('Văn xương', 'K', 6),
  58: _S('Văn Khúc', 'T', 6),
  59: _S('Thiên khôi', 'H', 6),
  60: _S('Thiên việt', 'H', 6),
  61: _S('Tả phù', 'O', 2),
  62: _S('Hữu bật', 'O', 2),
  63: _S('Long trì', 'T', 3),
  64: _S('Phượng các', 'O', 3),
  65: _S('Tam thai', 'M', 7),
  66: _S('Bát tọa', 'T', 7),
  67: _S('Ân quang', 'M', 3),
  68: _S('Thiên quý', 'O', 3),
  69: _S('Thiên khốc', 'T', 12),
  70: _S('Thiên hư', 'T', 12),
  71: _S('Thiên đức', 'H', 5),
  72: _S('Nguyệt đức', 'H', 5),
  73: _S('Thiên hình', 'H', 15),
  74: _S('Thiên riêu', 'T', 13),
  75: _S('Thiên y', 'T', 5),
  76: _S('Quốc ấn', 'O', 6),
  77: _S('Đường phù', 'M', 4),
  78: _S('Đào hoa', 'M', 8),
  79: _S('Hồng loan', 'T', 8),
  80: _S('Thiên hỷ', 'T', 5),
  81: _S('Thiên giải', 'H', 5),
  82: _S('Địa giải', 'O', 5),
  83: _S('Giải thần', 'M', 5),
  84: _S('Thai phụ', 'K', 6),
  85: _S('Phong cáo', 'O', 4),
  86: _S('Thiên tài', 'O', 2),
  87: _S('Thiên thọ', 'O', 5),
  88: _S('Thiên thương', 'O', 12),
  89: _S('Thiên sứ', 'T', 12),
  90: _S('Thiên la', 'O', 12),
  91: _S('Địa võng', 'O', 12),
  92: _S('Hóa khoa', 'T', 5),
  93: _S('Hóa quyền', 'T', 4),
  94: _S('Hóa lộc', 'M', 3),
  95: _S('Hóa kỵ', 'T', 13),
  96: _S('Cô thần', 'O', 13),
  97: _S('Quả tú', 'O', 13),
  98: _S('Thiên mã', 'H', 3),
  99: _S('Phá toái', 'H', 12),
  100: _S('Thiên quan', 'H', 5),
  101: _S('Thiên phúc', 'H', 5),
  102: _S('Lưu hà', 'T', 12),
  103: _S('Thiên trù', 'O', 5),
  104: _S('Kiếp sát', 'H', 11),
  105: _S('Hoa cái', 'K', 14),
  106: _S('Văn tinh', 'H', 6),
  107: _S('Đẩu quân', 'H', 5),
  108: _S('Thiên không', 'T', 11),
  109: _S('Bác sỹ', 'T', 5),
};

// Miếu/Vượng/Đắc/Bình/Hãm theo (saoId, vị trí cung 1..12). '' = không xét.
const Map<int, List<String>> _brightness = {
  1: ['B', 'Đ', 'M', 'B', 'V', 'M', 'M', 'Đ', 'M', 'B', 'V', 'B'],
  2: ['V', 'Đ', 'V', 'H', 'M', 'H', 'V', 'Đ', 'V', 'H', 'M', 'H'],
  3: ['V', 'H', 'M', 'Đ', 'H', 'Đ', 'H', 'H', 'M', 'H', 'H', 'Đ'],
  4: ['V', 'M', 'V', 'Đ', 'M', 'H', 'V', 'M', 'V', 'Đ', 'M', 'H'],
  5: ['H', 'Đ', 'V', 'V', 'V', 'M', 'M', 'Đ', 'H', 'H', 'H', 'H'],
  6: ['Đ', 'Đ', 'H', 'M', 'M', 'V', 'Đ', 'Đ', 'V', 'M', 'M', 'H'],
  8: ['V', 'Đ', 'H', 'H', 'H', 'H', 'H', 'Đ', 'V', 'M', 'M', 'M'],
  9: ['H', 'M', 'Đ', 'H', 'V', 'H', 'H', 'M', 'Đ', 'H', 'V', 'H'],
  10: ['V', 'H', 'V', 'M', 'H', 'H', 'V', 'H', 'Đ', 'M', 'H', 'Đ'],
  11: ['V', 'Đ', 'M', 'H', 'V', 'Đ', 'V', 'Đ', 'M', 'H', 'V', 'Đ'],
  12: ['V', 'Đ', 'V', 'V', 'M', 'H', 'M', 'Đ', 'V', 'H', 'M', 'H'],
  13: ['M', 'Đ', 'M', 'H', 'H', 'V', 'M', 'Đ', 'M', 'H', 'H', 'V'],
  14: ['M', 'V', 'H', 'H', 'Đ', 'H', 'M', 'V', 'H', 'H', 'Đ', 'H'],
  30: ['', '', 'Đ', 'Đ', '', '', '', '', 'Đ', 'Đ', '', ''],
  36: ['', '', 'Đ', 'Đ', '', '', '', '', 'Đ', 'Đ', '', ''],
  51: ['H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H'],
  52: ['H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H'],
  53: ['H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ'],
  54: ['H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ', 'H', 'H', 'Đ'],
  55: ['H', 'H', 'Đ', 'Đ', 'Đ', 'Đ', 'Đ', 'H', 'H', 'H', 'H', 'H'],
  56: ['H', 'H', 'Đ', 'Đ', 'Đ', 'Đ', 'Đ', 'H', 'H', 'H', 'H', 'H'],
  57: ['H', 'Đ', 'H', 'Đ', 'H', 'Đ', 'H', 'Đ', 'H', 'H', 'Đ', 'Đ'],
  58: ['H', 'Đ', 'H', 'Đ', 'H', 'Đ', 'H', 'Đ', 'H', 'H', 'Đ', 'Đ'],
  69: ['Đ', 'Đ', '', 'Đ', '', '', 'Đ', 'Đ', '', 'Đ', '', ''],
  70: ['Đ', 'Đ', '', 'Đ', '', '', 'Đ', 'Đ', '', 'Đ', '', ''],
  73: ['', '', 'Đ', 'Đ', '', '', '', '', 'Đ', 'Đ', '', ''],
  74: ['', '', 'Đ', 'Đ', '', '', '', '', '', 'Đ', 'Đ', ''],
  95: ['', 'Đ', '', '', 'Đ', '', '', 'Đ', '', '', 'Đ', ''],
  98: ['', '', 'Đ', '', '', 'Đ', '', '', '', '', '', ''],
};

// Bảng tra Ngũ hành Cục theo (cung Mệnh 1..12, can năm 1..10). Sinh từ reference.
const List<List<int>> _cucTable = [
  [2, 6, 5, 3, 4, 2, 6, 5, 3, 4], // cung 1
  [2, 6, 5, 3, 4, 2, 6, 5, 3, 4], // cung 2
  [6, 5, 3, 4, 2, 6, 5, 3, 4, 2], // cung 3
  [6, 5, 3, 4, 2, 6, 5, 3, 4, 2], // cung 4
  [3, 4, 2, 6, 5, 3, 4, 2, 6, 5], // cung 5
  [3, 4, 2, 6, 5, 3, 4, 2, 6, 5], // cung 6
  [5, 3, 4, 2, 6, 5, 3, 4, 2, 6], // cung 7
  [5, 3, 4, 2, 6, 5, 3, 4, 2, 6], // cung 8
  [4, 2, 6, 5, 3, 4, 2, 6, 5, 3], // cung 9
  [4, 2, 6, 5, 3, 4, 2, 6, 5, 3], // cung 10
  [6, 5, 3, 4, 2, 6, 5, 3, 4, 2], // cung 11
  [6, 5, 3, 4, 2, 6, 5, 3, 4, 2], // cung 12
];

const Map<int, String> _cucTen = {
  2: 'Thủy nhị Cục',
  3: 'Mộc tam Cục',
  4: 'Kim tứ Cục',
  5: 'Thổ ngũ Cục',
  6: 'Hỏa lục Cục',
};

const Map<String, String> _hanhFull = {
  'K': 'Kim',
  'M': 'Mộc',
  'T': 'Thủy',
  'H': 'Hỏa',
  'O': 'Thổ',
};

// Tên 12 cung chức (theo thứ tự từ cung Mệnh đi thuận).
const List<String> _tenCungChuc = [
  'Mệnh',
  'Phụ mẫu',
  'Phúc đức',
  'Điền trạch',
  'Quan lộc',
  'Nô bộc',
  'Thiên di',
  'Tật ách',
  'Tài bạch',
  'Tử tức',
  'Phu thê',
  'Huynh đệ',
];

// Vị trí Lộc tồn trên địa bàn theo can năm (1-based).
const List<int> _vitriLocTon = [0, 3, 4, 6, 7, 6, 7, 9, 10, 12, 1];

// Mệnh chủ theo địa chi cung Mệnh (1..12).
const List<String> _menhChu = [
  '',
  'Tham lang',
  'Cự môn',
  'Lộc tồn',
  'Văn khúc',
  'Liêm trinh',
  'Vũ khúc',
  'Phá quân',
  'Vũ khúc',
  'Liêm trinh',
  'Văn khúc',
  'Lộc tồn',
  'Cự môn',
];

// Thân chủ theo địa chi năm sinh (1..12).
const List<String> _thanChu = [
  '',
  'Linh tinh',
  'Thiên tướng',
  'Thiên lương',
  'Thiên đồng',
  'Văn xương',
  'Thiên cơ',
  'Hỏa tinh',
  'Thiên tướng',
  'Thiên lương',
  'Thiên đồng',
  'Văn xương',
  'Thiên cơ',
];

// Tứ Hóa: theo can năm (1..10) -> [Hóa Lộc, Hóa Quyền, Hóa Khoa, Hóa Kỵ]
// mỗi phần tử là saoId của CHÍNH/PHỤ tinh được hóa.
const List<List<int>> _tuHoaSrc = [
  [], // 0 (không dùng)
  [2, 14, 4, 5], // Giáp
  [6, 12, 1, 8], // Ất
  [3, 6, 57, 2], // Bính
  [8, 3, 6, 10], // Đinh
  [9, 8, 62, 6], // Mậu
  [4, 9, 12, 58], // Kỷ
  [5, 4, 3, 8], // Canh
  [10, 5, 58, 57], // Tân
  [12, 1, 7, 4], // Nhâm
  [14, 10, 8, 9], // Quý
];

// ----------------------------------------------------------------------------
// Nhóm sao (cho hiển thị xếp nhóm).
// ----------------------------------------------------------------------------
enum NhomSao { chinhTinh, tuHoa, phuTinhTot, sat, vongTrangSinh, vongThaiTue, vongLocTon, khac }

NhomSao _nhomCua(int id) {
  if (id >= 1 && id <= 14) return NhomSao.chinhTinh;
  if (id >= 92 && id <= 95) return NhomSao.tuHoa;
  if (const [51, 52, 53, 54, 55, 56, 104].contains(id)) return NhomSao.sat;
  if (const [57, 58, 59, 60, 61, 62, 27, 98].contains(id)) return NhomSao.phuTinhTot;
  if (id >= 39 && id <= 50) return NhomSao.vongTrangSinh;
  if (id >= 15 && id <= 26) return NhomSao.vongThaiTue;
  if ((id >= 28 && id <= 38) || id == 109) return NhomSao.vongLocTon;
  return NhomSao.khac;
}

// ----------------------------------------------------------------------------
// Model công khai.
// ----------------------------------------------------------------------------
class SaoTuVi {
  final int id;
  final String ten;
  final String nguHanh; // Kim/Mộc/Thủy/Hỏa/Thổ
  final String? dacTinh; // Miếu/Vượng/Đắc/Bình/Hãm hoặc null
  final NhomSao nhom;
  final bool laChinhTinh;

  const SaoTuVi(this.id, this.ten, this.nguHanh, this.dacTinh, this.nhom, this.laChinhTinh);
}

class CungTuVi {
  final int viTri; // 1..12 (1=Tý)
  final String chi; // tên địa chi
  final String tenCung; // Mệnh/Phụ mẫu/...
  final String canChi; // can chi an cho cung
  final String hanhCung;
  final bool laThan;
  final int daiHanTu; // tuổi bắt đầu đại hạn (âm lịch)
  final String tieuHanChi; // chi ứng tiểu hạn
  final bool tuan;
  final bool triet;
  final List<SaoTuVi> sao;

  const CungTuVi({
    required this.viTri,
    required this.chi,
    required this.tenCung,
    required this.canChi,
    required this.hanhCung,
    required this.laThan,
    required this.daiHanTu,
    required this.tieuHanChi,
    required this.tuan,
    required this.triet,
    required this.sao,
  });

  /// Các chính tinh trong cung (rỗng = vô chính diệu).
  List<SaoTuVi> get chinhTinh => sao.where((s) => s.laChinhTinh).toList();
  bool get voChinhDieu => chinhTinh.isEmpty;
}

class LaSoTuVi {
  final LunarDate lunar;
  final String canChiNam;
  final int cucSo; // 2..6
  final String cucTen; // "Thủy nhị Cục"...
  final Gender gioiTinh;
  final int gioSinhChi; // 0..11
  final int viTriMenh; // 1..12
  final int viTriThan;
  final String menhChu;
  final String thanChu;
  final String amDuongMenh; // "Dương Nam"...
  final List<CungTuVi> cung; // 12 cung, viTri 1..12

  const LaSoTuVi({
    required this.lunar,
    required this.canChiNam,
    required this.cucSo,
    required this.cucTen,
    required this.gioiTinh,
    required this.gioSinhChi,
    required this.viTriMenh,
    required this.viTriThan,
    required this.menhChu,
    required this.thanChu,
    required this.amDuongMenh,
    required this.cung,
  });

  CungTuVi get cungMenh => cung.firstWhere((c) => c.viTri == viTriMenh);
  CungTuVi get cungThan => cung.firstWhere((c) => c.viTri == viTriThan);
  CungTuVi cungTen(String ten) => cung.firstWhere((c) => c.tenCung == ten);
}

// ----------------------------------------------------------------------------
// Hàm tiện ích nội bộ (1-based).
// ----------------------------------------------------------------------------
int _dich(int base, int o1, [int o2 = 0, int o3 = 0]) {
  final v = (base + o1 + o2 + o3) % 12;
  return v == 0 ? 12 : (v < 0 ? v + 12 : v);
}

int _khoangCach(int c1, int c2, int chieu) =>
    chieu == 1 ? (c1 - c2 + 12) % 12 : (c2 - c1 + 12) % 12;

int _timTuVi(int cuc, int ngay) {
  int cungDan = 3;
  int c = cuc;
  while (c < ngay) {
    c += cuc;
    cungDan++;
  }
  int saiLech = c - ngay;
  if (saiLech % 2 == 1) saiLech = -saiLech;
  return _dich(cungDan, saiLech);
}

int _timTrangSinh(int cuc) {
  switch (cuc) {
    case 6:
      return 3;
    case 4:
      return 6;
    case 2:
    case 5:
      return 9;
    case 3:
      return 12;
    default:
      return 3;
  }
}

List<int> _timHoaLinh(int chiNam, int gio, int gioiTinh, int amDuongNam) {
  int khoiHoa, khoiLinh;
  if (const [3, 7, 11].contains(chiNam)) {
    khoiHoa = 2;
    khoiLinh = 4;
  } else if (const [1, 5, 9].contains(chiNam)) {
    khoiHoa = 3;
    khoiLinh = 11;
  } else if (const [6, 10, 2].contains(chiNam)) {
    khoiHoa = 11;
    khoiLinh = 4;
  } else {
    khoiHoa = 10;
    khoiLinh = 11;
  }
  int hoa, linh;
  if (gioiTinh * amDuongNam == -1) {
    hoa = _dich(khoiHoa + 1, -gio);
    linh = _dich(khoiLinh - 1, gio);
  } else {
    hoa = _dich(khoiHoa - 1, gio);
    linh = _dich(khoiLinh + 1, -gio);
  }
  return [hoa, linh];
}

const List<int> _khoiBang = [0, 2, 1, 12, 10, 8, 1, 8, 7, 6, 4];
const List<int> _thienQuanBang = [0, 8, 5, 6, 3, 4, 10, 12, 10, 11, 7];
const List<int> _thienPhucBang = [0, 10, 9, 1, 12, 4, 3, 7, 6, 7, 6];
const List<int> _luuHaBang = [0, 10, 11, 8, 5, 6, 7, 9, 4, 12, 3];
const List<int> _thienTruBang = [0, 6, 7, 1, 6, 7, 9, 3, 7, 10, 11];

int _timCoThan(int chiNam) {
  if (const [12, 1, 2].contains(chiNam)) return 3;
  if (const [3, 4, 5].contains(chiNam)) return 6;
  if (const [6, 7, 8].contains(chiNam)) return 9;
  return 12;
}

int _timThienMa(int chiNam) {
  switch (chiNam % 4) {
    case 1:
      return 3;
    case 2:
      return 12;
    case 3:
      return 9;
    default:
      return 6; // 0
  }
}

int _timPhaToai(int chiNam) {
  switch (chiNam % 3) {
    case 0:
      return 6;
    case 1:
      return 10;
    default:
      return 2; // 2
  }
}

List<int> _timTriet(int canNam) {
  if (const [1, 6].contains(canNam)) return [9, 10];
  if (const [2, 7].contains(canNam)) return [7, 8];
  if (const [3, 8].contains(canNam)) return [5, 6];
  if (const [4, 9].contains(canNam)) return [3, 4];
  return [1, 2]; // 5,10
}

int _amDuongCan(int can) => can % 2 == 1 ? 1 : -1;
int _amDuongChi(int chi) => chi % 2 == 1 ? 1 : -1;

// ----------------------------------------------------------------------------
// Lập lá số.
// ----------------------------------------------------------------------------

/// Lập lá số từ ngày dương lịch + giờ sinh (địa chi 0..11) + giới tính.
LaSoTuVi lapLaSoTuDuong(DateTime solar, int gioSinhChi, Gender gioiTinh) {
  final lunar = solarToLunar(solar.day, solar.month, solar.year);
  return lapLaSo(
    lunarDay: lunar.day,
    lunarMonth: lunar.month,
    lunarYear: lunar.year,
    gioSinhChi: gioSinhChi,
    gioiTinh: gioiTinh,
    lunarOverride: lunar,
  );
}

/// Lập lá số từ ngày/tháng/năm ÂM LỊCH + giờ sinh (địa chi 0..11) + giới tính.
LaSoTuVi lapLaSo({
  required int lunarDay,
  required int lunarMonth,
  required int lunarYear,
  required int gioSinhChi, // 0..11 (Tý..Hợi)
  required Gender gioiTinh,
  LunarDate? lunarOverride,
}) {
  final nn = lunarDay;
  final tt = lunarMonth;
  final gio = gioSinhChi + 1; // 1..12
  final gt = gioiTinh == Gender.nam ? 1 : -1;

  // Can chi năm (1-based) suy từ năm âm lịch.
  final canNam = (lunarYear + 6) % 10 + 1;
  final chiNam = (lunarYear + 8) % 12 + 1;
  final amDuongCanNam = _amDuongCan(canNam);
  final amDuongChiNam = _amDuongChi(chiNam);

  // Cung Mệnh / Thân.
  final viTriMenh = _dich(3, tt - 1, -gio + 1);
  final viTriThan = _dich(3, tt - 1, gio - 1);

  // Ngũ hành cục.
  final cucSo = _cucTable[viTriMenh - 1][canNam - 1];

  // Bảng địa bàn: mỗi cung -> danh sách saoId.
  final cungSao = List<List<int>>.generate(13, (_) => <int>[]);
  final posOf = <int, int>{}; // saoId -> cung (sao đơn)
  void place(int cung, int id) {
    cungSao[cung].add(id);
    posOf[id] = cung;
  }

  // --- Tử Vi tinh hệ ---
  final viTriTuVi = _timTuVi(cucSo, nn);
  place(viTriTuVi, 1);
  place(_dich(viTriTuVi, 4), 2); // Liêm trinh
  place(_dich(viTriTuVi, 7), 3); // Thiên đồng
  place(_dich(viTriTuVi, 8), 4); // Vũ khúc
  place(_dich(viTriTuVi, 9), 5); // Thái dương
  place(_dich(viTriTuVi, 11), 6); // Thiên cơ

  // --- Thiên Phủ tinh hệ ---
  final viTriThienPhu = _dich(3, 3 - viTriTuVi);
  place(viTriThienPhu, 7);
  place(_dich(viTriThienPhu, 1), 8); // Thái âm
  place(_dich(viTriThienPhu, 2), 9); // Tham lang
  place(_dich(viTriThienPhu, 3), 10); // Cự môn
  place(_dich(viTriThienPhu, 4), 11); // Thiên tướng
  place(_dich(viTriThienPhu, 5), 12); // Thiên lương
  place(_dich(viTriThienPhu, 6), 13); // Thất sát
  place(_dich(viTriThienPhu, 10), 14); // Phá quân

  // --- Vòng Lộc Tồn (theo can năm) ---
  final viTriLocTon = _vitriLocTon[canNam];
  place(viTriLocTon, 27);
  place(viTriLocTon, 109); // Bác sỹ cùng cung Lộc tồn
  final adNamNu = gt * amDuongCanNam;
  place(_dich(viTriLocTon, 1 * adNamNu), 28); // Lực sĩ
  place(_dich(viTriLocTon, 2 * adNamNu), 29); // Thanh long
  place(_dich(viTriLocTon, 3 * adNamNu), 30); // Tiểu hao
  place(_dich(viTriLocTon, 4 * adNamNu), 31); // Tướng quân
  place(_dich(viTriLocTon, 5 * adNamNu), 32); // Tấu thư
  place(_dich(viTriLocTon, 6 * adNamNu), 33); // Phi liêm
  place(_dich(viTriLocTon, 7 * adNamNu), 34); // Hỷ thần
  place(_dich(viTriLocTon, 8 * adNamNu), 35); // Bệnh phù
  place(_dich(viTriLocTon, 9 * adNamNu), 36); // Đại hao
  place(_dich(viTriLocTon, 10 * adNamNu), 37); // Phục binh
  place(_dich(viTriLocTon, 11 * adNamNu), 38); // Quan phù

  // --- Vòng Thái Tuế (theo chi năm) ---
  final viTriThaiTue = chiNam;
  place(viTriThaiTue, 15);
  place(_dich(viTriThaiTue, 1), 16); // Thiếu dương
  place(_dich(viTriThaiTue, 1), 108); // Thiên không (cùng cung Thiếu dương)
  place(_dich(viTriThaiTue, 2), 17); // Tang môn
  place(_dich(viTriThaiTue, 3), 18); // Thiếu âm
  place(_dich(viTriThaiTue, 4), 19); // Quan phù
  place(_dich(viTriThaiTue, 5), 20); // Tử phù
  place(_dich(viTriThaiTue, 5), 72); // Nguyệt đức
  place(_dich(viTriThaiTue, 6), 21); // Tuế phá
  place(_dich(viTriThaiTue, 7), 22); // Long đức
  place(_dich(viTriThaiTue, 8), 23); // Bạch hổ
  place(_dich(viTriThaiTue, 9), 24); // Phúc đức
  place(_dich(viTriThaiTue, 9), 71); // Thiên đức
  place(_dich(viTriThaiTue, 10), 25); // Điếu khách
  place(_dich(viTriThaiTue, 11), 26); // Trực phù

  // --- Vòng Tràng Sinh (theo cục) ---
  final viTriTrangSinh = _timTrangSinh(cucSo);
  place(viTriTrangSinh, 39);
  place(_dich(viTriTrangSinh, adNamNu * 1), 40); // Mộc dục
  place(_dich(viTriTrangSinh, adNamNu * 2), 41); // Quan đới
  place(_dich(viTriTrangSinh, adNamNu * 3), 42); // Lâm quan
  place(_dich(viTriTrangSinh, adNamNu * 4), 43); // Đế vượng
  place(_dich(viTriTrangSinh, adNamNu * 5), 44); // Suy
  place(_dich(viTriTrangSinh, adNamNu * 6), 45); // Bệnh
  place(_dich(viTriTrangSinh, adNamNu * 7), 46); // Tử
  place(_dich(viTriTrangSinh, adNamNu * 8), 47); // Mộ
  place(_dich(viTriTrangSinh, adNamNu * 9), 48); // Tuyệt
  place(_dich(viTriTrangSinh, adNamNu * -1), 49); // Thai
  place(_dich(viTriTrangSinh, adNamNu * -2), 50); // Dưỡng

  // --- Kình Dương - Đà La ---
  place(_dich(viTriLocTon, -1), 51); // Đà la
  place(_dich(viTriLocTon, 1), 52); // Kình dương

  // --- Địa Không - Địa Kiếp ---
  final viTriDiaKiep = _dich(11, gio);
  place(viTriDiaKiep, 54);
  place(_dich(12, 12 - viTriDiaKiep), 53); // Địa không

  // --- Hỏa Tinh - Linh Tinh ---
  final hoaLinh = _timHoaLinh(chiNam, gio, gt, amDuongCanNam);
  place(hoaLinh[0], 56); // Hỏa tinh
  place(hoaLinh[1], 55); // Linh tinh

  // --- Long Trì - Phượng Các ---
  final viTriLongTri = _dich(5, chiNam - 1);
  place(viTriLongTri, 63);
  final viTriPhuongCac = _dich(2, 2 - viTriLongTri);
  place(viTriPhuongCac, 64);
  place(viTriPhuongCac, 83); // Giải thần

  // --- Tả Phù - Hữu Bật ---
  final viTriTaPhu = _dich(5, tt - 1);
  place(viTriTaPhu, 61);
  final viTriHuuBat = _dich(2, 2 - viTriTaPhu);
  place(viTriHuuBat, 62);

  // --- Văn Khúc - Văn Xương ---
  final viTriVanKhuc = _dich(5, gio - 1);
  place(viTriVanKhuc, 58);
  final viTriVanXuong = _dich(2, 2 - viTriVanKhuc);
  place(viTriVanXuong, 57);

  // --- Tam Thai - Bát Tọa ---
  final viTriTamThai = _dich(5, tt + nn - 2);
  place(viTriTamThai, 65);
  place(_dich(2, 2 - viTriTamThai), 66);

  // --- Ân Quang - Thiên Quý ---
  final viTriAnQuang = _dich(viTriVanXuong, nn - 2);
  place(viTriAnQuang, 67);
  place(_dich(2, 2 - viTriAnQuang), 68);

  // --- Thiên Khôi - Thiên Việt ---
  final viTriThienKhoi = _khoiBang[canNam];
  place(viTriThienKhoi, 59);
  place(_dich(5, 5 - viTriThienKhoi), 60);

  // --- Thiên Hư - Thiên Khốc ---
  place(_dich(7, chiNam - 1), 70);
  place(_dich(7, -chiNam + 1), 69);

  // --- Thiên Tài - Thiên Thọ ---
  place(_dich(viTriMenh, chiNam - 1), 86);
  place(_dich(viTriThan, chiNam - 1), 87);

  // --- Hồng Loan - Thiên Hỷ ---
  final viTriHongLoan = _dich(4, -chiNam + 1);
  place(viTriHongLoan, 79);
  place(_dich(viTriHongLoan, 6), 80);

  // --- Thiên Quan - Thiên Phúc ---
  place(_thienQuanBang[canNam], 100);
  place(_thienPhucBang[canNam], 101);

  // --- Thiên Hình - Thiên Riêu - Thiên Y ---
  final viTriThienHinh = _dich(10, tt - 1);
  place(viTriThienHinh, 73);
  final viTriThienRieu = _dich(viTriThienHinh, 4);
  place(viTriThienRieu, 74);
  place(viTriThienRieu, 75); // Thiên y

  // --- Cô Thần - Quả Tú ---
  final viTriCoThan = _timCoThan(chiNam);
  place(viTriCoThan, 96);
  place(_dich(viTriCoThan, -4), 97);

  // --- Văn Tinh - Đường Phù - Quốc Ấn ---
  final viTriVanTinh = _dich(_dich(viTriLocTon, 1), 2); // = Kình dương + 2
  place(viTriVanTinh, 106);
  final viTriDuongPhu = _dich(viTriVanTinh, 2);
  place(viTriDuongPhu, 77);
  place(_dich(viTriDuongPhu, 3), 76); // Quốc ấn

  // --- Thai Phụ - Phong Cáo ---
  place(_dich(viTriVanKhuc, 2), 84);
  place(_dich(viTriVanKhuc, -2), 85);

  // --- Thiên Giải - Địa Giải ---
  place(_dich(9, 2 * tt - 2), 81);
  place(_dich(viTriTaPhu, 3), 82);

  // --- Thiên La - Địa Võng - Thiên Thương - Thiên Sứ ---
  place(5, 90); // Thiên la cố định Thìn
  place(11, 91); // Địa võng cố định Tuất
  place(_dich(viTriMenh, 5), 88); // Thiên thương = cung Nô bộc
  place(_dich(viTriMenh, 7), 89); // Thiên sứ = cung Tật ách

  // --- Vòng Thiên Mã ---
  final viTriThienMa = _timThienMa(chiNam);
  place(viTriThienMa, 98);
  place(_dich(viTriThienMa, 2), 105); // Hoa cái
  final viTriKiepSat = _dich(viTriThienMa, 3);
  place(viTriKiepSat, 104);
  place(_dich(viTriKiepSat, 4), 78); // Đào hoa

  // --- Phá Toái ---
  place(_timPhaToai(chiNam), 99);

  // --- Đẩu Quân ---
  place(_dich(chiNam, -tt + gio), 107);

  // --- Tứ Hóa (theo can năm) ---
  final src = _tuHoaSrc[canNam];
  place(posOf[src[0]]!, 94); // Hóa lộc
  place(posOf[src[1]]!, 93); // Hóa quyền
  place(posOf[src[2]]!, 92); // Hóa khoa
  place(posOf[src[3]]!, 95); // Hóa kỵ

  // --- Lưu Hà - Thiên Trù ---
  place(_luuHaBang[canNam], 102);
  place(_thienTruBang[canNam], 103);

  // --- Tuần ---
  final ketThucTuan = _dich(chiNam, 10 - canNam);
  final tuan1 = _dich(ketThucTuan, 1);
  final tuan2 = _dich(tuan1, 1);
  // --- Triệt ---
  final triet = _timTriet(canNam);

  // --- Đại hạn / Tiểu hạn ---
  final dirDaiHan = gt * amDuongChiNam;
  final khoiTieuHan = _dich(11, -3 * (chiNam - 1));
  final cungTy1 = _dich(khoiTieuHan, -gt * (chiNam - 1));

  // Can an cho từng cung (ngũ hổ độn).
  var canThangGieng = (canNam * 2 + 1) % 10;
  if (canThangGieng == 0) canThangGieng = 10;

  const tenCanList = [
    '', 'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý',
  ];
  const tenChiList = [
    '', 'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi',
  ];
  const hanhCungList = [
    '', 'Thủy', 'Thổ', 'Mộc', 'Mộc', 'Thổ', 'Hỏa', 'Hỏa', 'Thổ', 'Kim', 'Kim', 'Thổ', 'Thủy',
  ];

  String canChoCung(int viTri) {
    var v = ((viTri - 3) % 12 + canThangGieng) % 10;
    if (v == 0) v = 10;
    return tenCanList[v];
  }

  // Tên cung chức: từ cung Mệnh đi thuận.
  final tenCungTheoViTri = <int, String>{};
  for (var i = 0; i < 12; i++) {
    tenCungTheoViTri[_dich(viTriMenh, i)] = _tenCungChuc[i];
  }

  final cungList = <CungTuVi>[];
  for (var v = 1; v <= 12; v++) {
    final khoangCachDH = _khoangCach(v, viTriMenh, dirDaiHan);
    final daiHanTu = cucSo + khoangCachDH * 10;
    final tieuHanIdx = _khoangCach(v, cungTy1, gt);
    final saoList = cungSao[v].map((id) {
      final def = _catalog[id]!;
      final bRow = _brightness[id];
      String? dt;
      if (bRow != null) {
        final code = bRow[v - 1];
        dt = const {
          'M': 'Miếu',
          'V': 'Vượng',
          'Đ': 'Đắc',
          'B': 'Bình',
          'H': 'Hãm',
        }[code];
      }
      return SaoTuVi(id, def.ten, _hanhFull[def.nguHanh] ?? def.nguHanh, dt,
          _nhomCua(id), def.loai == 1);
    }).toList()
      ..sort((a, b) => _sortKey(a).compareTo(_sortKey(b)));

    cungList.add(CungTuVi(
      viTri: v,
      chi: tenChiList[v],
      tenCung: tenCungTheoViTri[v] ?? '',
      canChi: '${canChoCung(v)} ${tenChiList[v]}',
      hanhCung: hanhCungList[v],
      laThan: v == viTriThan,
      daiHanTu: daiHanTu,
      tieuHanChi: tenChiList[tieuHanIdx + 1],
      tuan: v == tuan1 || v == tuan2,
      triet: v == triet[0] || v == triet[1],
      sao: saoList,
    ));
  }

  final amDuongLabel =
      '${amDuongCanNam == 1 ? 'Dương' : 'Âm'} ${gt == 1 ? 'Nam' : 'Nữ'}';

  return LaSoTuVi(
    lunar: lunarOverride ?? LunarDate(nn, tt, lunarYear),
    canChiNam: '${thienCan[(lunarYear + 6) % 10]} ${diaChi[(lunarYear + 8) % 12]}',
    cucSo: cucSo,
    cucTen: _cucTen[cucSo] ?? '',
    gioiTinh: gioiTinh,
    gioSinhChi: gioSinhChi,
    viTriMenh: viTriMenh,
    viTriThan: viTriThan,
    menhChu: _menhChu[viTriMenh],
    thanChu: _thanChu[chiNam],
    amDuongMenh: amDuongLabel,
    cung: cungList,
  );
}

// Thứ tự hiển thị sao trong cung: chính tinh -> tứ hóa -> phụ tốt -> sát -> ...
int _sortKey(SaoTuVi s) {
  switch (s.nhom) {
    case NhomSao.chinhTinh:
      return 0;
    case NhomSao.tuHoa:
      return 1;
    case NhomSao.phuTinhTot:
      return 2;
    case NhomSao.sat:
      return 3;
    case NhomSao.vongThaiTue:
      return 5;
    case NhomSao.vongLocTon:
      return 6;
    case NhomSao.vongTrangSinh:
      return 7;
    case NhomSao.khac:
      return 4;
  }
}

// ----------------------------------------------------------------------------
// Helper "luận theo tuổi" — chỉ cần NĂM sinh, KHÔNG cần giờ (không lập lá số).
// Dùng cho chế độ 📖 Dễ hiểu. Chỉ phơi bày các bảng có sẵn ở trên.
// ----------------------------------------------------------------------------

/// Một sao mang Tứ Hóa của năm sinh.
class HoaSao {
  final String ten; // tên sao được hóa (vd "Tham lang")
  final String hoa; // "Hóa lộc" | "Hóa quyền" | "Hóa khoa" | "Hóa kỵ"
  const HoaSao(this.ten, this.hoa);
}

const List<String> _tenTuHoa = ['Hóa lộc', 'Hóa quyền', 'Hóa khoa', 'Hóa kỵ'];

/// Chỉ số can năm (1..10, Giáp=1) từ năm âm lịch.
int canNamCuaNam(int lunarYear) => (lunarYear + 6) % 10 + 1;

/// Chỉ số chi năm (1..12, Tý=1) từ năm âm lịch.
int chiNamCuaNam(int lunarYear) => (lunarYear + 8) % 12 + 1;

/// Tứ Hóa của năm sinh theo can năm (1..10, Giáp=1). Không cần giờ.
List<HoaSao> tuHoaCuaCanNam(int canNam) {
  final src = _tuHoaSrc[canNam];
  return [
    for (var i = 0; i < 4; i++) HoaSao(_catalog[src[i]]!.ten, _tenTuHoa[i]),
  ];
}

/// Thân chủ theo chi năm (1..12, Tý=1). Không cần giờ.
String thanChuCuaChiNam(int chiNam) => _thanChu[chiNam];
