/// Nạp âm ngũ hành (60 hoa giáp → 30 nạp âm).
/// Mỗi cặp can-chi liên tiếp chung 1 nạp âm.
library;

class NapAm {
  final String name; // vd "Đại Lâm Mộc"
  final String element; // Kim / Mộc / Thủy / Hỏa / Thổ
  const NapAm(this.name, this.element);
}

// 30 nạp âm theo thứ tự bắt đầu từ Giáp Tý.
const List<NapAm> _napAm = [
  NapAm('Hải Trung Kim', 'Kim'),
  NapAm('Lư Trung Hỏa', 'Hỏa'),
  NapAm('Đại Lâm Mộc', 'Mộc'),
  NapAm('Lộ Bàng Thổ', 'Thổ'),
  NapAm('Kiếm Phong Kim', 'Kim'),
  NapAm('Sơn Đầu Hỏa', 'Hỏa'),
  NapAm('Giản Hạ Thủy', 'Thủy'),
  NapAm('Thành Đầu Thổ', 'Thổ'),
  NapAm('Bạch Lạp Kim', 'Kim'),
  NapAm('Dương Liễu Mộc', 'Mộc'),
  NapAm('Tuyền Trung Thủy', 'Thủy'),
  NapAm('Ốc Thượng Thổ', 'Thổ'),
  NapAm('Tích Lịch Hỏa', 'Hỏa'),
  NapAm('Tùng Bách Mộc', 'Mộc'),
  NapAm('Trường Lưu Thủy', 'Thủy'),
  NapAm('Sa Trung Kim', 'Kim'),
  NapAm('Sơn Hạ Hỏa', 'Hỏa'),
  NapAm('Bình Địa Mộc', 'Mộc'),
  NapAm('Bích Thượng Thổ', 'Thổ'),
  NapAm('Kim Bạch Kim', 'Kim'),
  NapAm('Phú Đăng Hỏa', 'Hỏa'),
  NapAm('Thiên Hà Thủy', 'Thủy'),
  NapAm('Đại Trạch Thổ', 'Thổ'),
  NapAm('Thoa Xuyến Kim', 'Kim'),
  NapAm('Tang Đố Mộc', 'Mộc'),
  NapAm('Đại Khê Thủy', 'Thủy'),
  NapAm('Sa Trung Thổ', 'Thổ'),
  NapAm('Thiên Thượng Hỏa', 'Hỏa'),
  NapAm('Thạch Lựu Mộc', 'Mộc'),
  NapAm('Đại Hải Thủy', 'Thủy'),
];

/// Chỉ số trong vòng 60 (sexagenary) từ can (0-9) và chi (0-11).
int _sexagenary(int can, int chi) {
  for (var i = 0; i < 60; i++) {
    if (i % 10 == can && i % 12 == chi) return i;
  }
  return 0;
}

/// Nạp âm của một can-chi (theo chỉ số can & chi).
NapAm napAmOf(int canIndex, int chiIndex) {
  return _napAm[_sexagenary(canIndex, chiIndex) ~/ 2];
}
