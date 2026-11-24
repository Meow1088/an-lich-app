/// Bát trạch: cung phi (quái mệnh) theo năm sinh âm lịch + giới tính,
/// Đông/Tây tứ mệnh, 8 hướng (du tinh tốt/xấu), ngũ hành mệnh + màu hợp.
/// THAM KHẢO / tín ngưỡng dân gian. Verify nguồn 2026-06-26:
///  - Cung phi: nam 1969=Tốn, nữ 1970=Chấn, nam 1972=Khảm.
///  - Du tinh: suy từ quy tắc biến hào (游年), đối chiếu cung Khảm & Càn.
library;

// 8 quái theo thứ tự HƯỚNG: 0 Khảm, 1 Cấn, 2 Chấn, 3 Tốn, 4 Ly, 5 Khôn, 6 Đoài, 7 Càn.
const List<String> queNames = [
  'Khảm', 'Cấn', 'Chấn', 'Tốn', 'Ly', 'Khôn', 'Đoài', 'Càn',
];
const List<String> queHuong = [
  'Bắc', 'Đông Bắc', 'Đông', 'Đông Nam', 'Nam', 'Tây Nam', 'Tây', 'Tây Bắc',
];
// Hào (top, mid, bottom), dương=1.
const List<List<int>> _queBits = [
  [0, 1, 0], // Khảm
  [1, 0, 0], // Cấn
  [0, 0, 1], // Chấn
  [1, 1, 0], // Tốn
  [1, 0, 1], // Ly
  [0, 0, 0], // Khôn
  [0, 1, 1], // Đoài
  [1, 1, 1], // Càn
];
const List<String> _queNguHanh = [
  'Thủy', 'Thổ', 'Mộc', 'Mộc', 'Hỏa', 'Thổ', 'Kim', 'Kim',
];
// Đông tứ mệnh: Khảm(0) Chấn(2) Tốn(3) Ly(4).
const Set<int> _dongTu = {0, 2, 3, 4};

// Số cửu tinh (Lạc thư) 1..9 -> quái index (5 xử lý riêng theo giới).
const Map<int, int> _soToQue = {
  1: 0, 2: 5, 3: 2, 4: 3, 6: 7, 7: 6, 8: 1, 9: 4,
};

// XOR 3 hào (key = t*4+m*2+b) -> du tinh.
class DuTinh {
  final String name;
  final bool tot;
  final String y; // ý nghĩa ngắn
  const DuTinh(this.name, this.tot, this.y);
}

const Map<int, DuTinh> _duTinh = {
  0: DuTinh('Phục Vị', true, 'Ổn định, củng cố'), // 000
  4: DuTinh('Sinh Khí', true, 'Tốt nhất: tài lộc, thăng tiến'), // 100 top
  3: DuTinh('Thiên Y', true, 'Sức khỏe, quý nhân'), // 011 mid+bottom
  7: DuTinh('Diên Niên', true, 'Hòa hợp, trường thọ'), // 111 all
  2: DuTinh('Tuyệt Mệnh', false, 'Xấu nhất: bệnh tật, hao tài'), // 010 mid
  6: DuTinh('Ngũ Quỷ', false, 'Thị phi, mất mát'), // 110 top+mid
  5: DuTinh('Lục Sát', false, 'Kiện tụng, tai tiếng'), // 101 top+bottom
  1: DuTinh('Họa Hại', false, 'Hao tổn, trắc trở'), // 001 bottom
};

int _reduce(int n) {
  while (n > 9) {
    var s = 0;
    var x = n;
    while (x > 0) {
      s += x % 10;
      x ~/= 10;
    }
    n = s;
  }
  return n;
}

/// Quái mệnh (0..7) từ năm sinh ÂL + giới tính (isNam).
int cungPhi(int birthLunarYear, bool isNam) {
  final a = _reduce(birthLunarYear % 100 ~/ 10 + birthLunarYear % 10);
  final before2000 = birthLunarYear < 2000;
  var num = isNam ? (before2000 ? 10 - a : 9 - a) : (before2000 ? 5 + a : 6 + a);
  num = _reduce(num);
  if (num == 0) num = 9; // nam 2000+: 9-9=0 -> Ly
  if (num == 5) num = isNam ? 2 : 8; // ngũ hoàng ký gửi
  return _soToQue[num]!;
}

class HuongInfo {
  final String huong; // 'Bắc'
  final DuTinh duTinh;
  const HuongInfo(this.huong, this.duTinh);
}

class BatTrach {
  final int que; // index 0..7
  final String menh; // ngũ hành
  final bool dongTu;
  final List<HuongInfo> huongs; // 8 hướng

  const BatTrach(this.que, this.menh, this.dongTu, this.huongs);

  String get queName => queNames[que];
  String get trach => dongTu ? 'Đông tứ mệnh' : 'Tây tứ mệnh';
  List<HuongInfo> get tot => huongs.where((h) => h.duTinh.tot).toList();
  List<HuongInfo> get xau => huongs.where((h) => !h.duTinh.tot).toList();
}

/// Du tinh giữa quái mệnh và 1 quái hướng.
DuTinh _duTinhGiua(int menhQue, int huongQue) {
  final a = _queBits[menhQue];
  final b = _queBits[huongQue];
  final key = (a[0] ^ b[0]) * 4 + (a[1] ^ b[1]) * 2 + (a[2] ^ b[2]);
  return _duTinh[key]!;
}

BatTrach batTrachOf(int birthLunarYear, bool isNam) {
  final que = cungPhi(birthLunarYear, isNam);
  final huongs = [
    for (var h = 0; h < 8; h++) HuongInfo(queHuong[h], _duTinhGiua(que, h)),
  ];
  return BatTrach(que, _queNguHanh[que], _dongTu.contains(que), huongs);
}

/// Màu hợp mệnh = màu bản mệnh + màu tương sinh (hành sinh ra nó).
const Map<String, String> mauHopMenh = {
  'Kim': 'Trắng, xám, ghi (bản mệnh) · Vàng, nâu (Thổ sinh Kim)',
  'Mộc': 'Xanh lá (bản mệnh) · Đen, xanh dương (Thủy sinh Mộc)',
  'Thủy': 'Đen, xanh dương (bản mệnh) · Trắng, xám (Kim sinh Thủy)',
  'Hỏa': 'Đỏ, hồng, cam (bản mệnh) · Xanh lá (Mộc sinh Hỏa)',
  'Thổ': 'Vàng, nâu (bản mệnh) · Đỏ, hồng (Hỏa sinh Thổ)',
};
