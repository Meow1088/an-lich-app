/// 63 tỉnh/thành (trước sáp nhập 2025) — kinh độ tỉnh lỵ, vùng múi giờ 1954–1975.
/// Nguồn: GeoNames (VN.txt, tải 09/11/2026), đối chiếu Wikidata P625: 63/63 lệch ≤ 0,072°
/// (≤ 17 giây giờ mặt trời). Vùng: Quảng Bình trở ra = Bắc, Quảng Trị trở vào = Nam
/// (vĩ tuyến 17; Vĩnh Linh thuộc Quảng Trị nhưng ở bờ Bắc là ca biên, chọn tỉnh Quảng Bình nếu cần).
library;

import 'gio_sinh_chuan.dart';

class NoiSinh {
  final String ten;
  final double kinhDo;
  final VungSinh vung;
  const NoiSinh(this.ten, this.kinhDo, this.vung);
}

const List<NoiSinh> kNoiSinh = [
  NoiSinh('Hà Nội', 105.8412, VungSinh.bac),
  NoiSinh('Hà Giang', 104.9836, VungSinh.bac),
  NoiSinh('Cao Bằng', 106.2579, VungSinh.bac),
  NoiSinh('Bắc Kạn', 105.8348, VungSinh.bac),
  NoiSinh('Tuyên Quang', 105.2142, VungSinh.bac),
  NoiSinh('Lào Cai', 103.9707, VungSinh.bac),
  NoiSinh('Điện Biên', 103.0230, VungSinh.bac),
  NoiSinh('Lai Châu', 103.4582, VungSinh.bac),
  NoiSinh('Sơn La', 103.9188, VungSinh.bac),
  NoiSinh('Yên Bái', 104.9113, VungSinh.bac),
  NoiSinh('Hòa Bình', 105.3376, VungSinh.bac),
  NoiSinh('Thái Nguyên', 105.8482, VungSinh.bac),
  NoiSinh('Lạng Sơn', 106.7610, VungSinh.bac),
  NoiSinh('Quảng Ninh', 107.0734, VungSinh.bac),
  NoiSinh('Bắc Giang', 106.1946, VungSinh.bac),
  NoiSinh('Phú Thọ', 105.4020, VungSinh.bac),
  NoiSinh('Vĩnh Phúc', 105.6049, VungSinh.bac),
  NoiSinh('Bắc Ninh', 106.0763, VungSinh.bac),
  NoiSinh('Hải Dương', 106.3330, VungSinh.bac),
  NoiSinh('Hải Phòng', 106.6834, VungSinh.bac),
  NoiSinh('Hưng Yên', 106.0511, VungSinh.bac),
  NoiSinh('Thái Bình', 106.3400, VungSinh.bac),
  NoiSinh('Hà Nam', 105.9122, VungSinh.bac),
  NoiSinh('Nam Định', 106.1773, VungSinh.bac),
  NoiSinh('Ninh Bình', 105.9797, VungSinh.bac),
  NoiSinh('Thanh Hóa', 105.7667, VungSinh.bac),
  NoiSinh('Nghệ An', 105.6923, VungSinh.bac),
  NoiSinh('Hà Tĩnh', 105.9057, VungSinh.bac),
  NoiSinh('Quảng Bình', 106.6223, VungSinh.bac),
  NoiSinh('Quảng Trị', 107.1003, VungSinh.nam),
  NoiSinh('Thừa Thiên Huế', 107.5955, VungSinh.nam),
  NoiSinh('Đà Nẵng', 108.2208, VungSinh.nam),
  NoiSinh('Quảng Nam', 108.4740, VungSinh.nam),
  NoiSinh('Quảng Ngãi', 108.7923, VungSinh.nam),
  NoiSinh('Bình Định', 109.2237, VungSinh.nam),
  NoiSinh('Phú Yên', 109.3209, VungSinh.nam),
  NoiSinh('Khánh Hòa', 109.1943, VungSinh.nam),
  NoiSinh('Ninh Thuận', 108.9886, VungSinh.nam),
  NoiSinh('Bình Thuận', 108.1021, VungSinh.nam),
  NoiSinh('Kon Tum', 108.0076, VungSinh.nam),
  NoiSinh('Gia Lai', 108.0000, VungSinh.nam),
  NoiSinh('Đắk Lắk', 108.0378, VungSinh.nam),
  NoiSinh('Đắk Nông', 107.6907, VungSinh.nam),
  NoiSinh('Lâm Đồng', 108.4419, VungSinh.nam),
  NoiSinh('Bình Phước', 106.8832, VungSinh.nam),
  NoiSinh('Tây Ninh', 106.0983, VungSinh.nam),
  NoiSinh('Bình Dương', 106.6519, VungSinh.nam),
  NoiSinh('Đồng Nai', 106.8243, VungSinh.nam),
  NoiSinh('Bà Rịa - Vũng Tàu', 107.1685, VungSinh.nam),
  NoiSinh('TP. Hồ Chí Minh', 106.7019, VungSinh.nam),
  NoiSinh('Long An', 106.4137, VungSinh.nam),
  NoiSinh('Tiền Giang', 106.3600, VungSinh.nam),
  NoiSinh('Bến Tre', 106.3758, VungSinh.nam),
  NoiSinh('Trà Vinh', 106.3423, VungSinh.nam),
  NoiSinh('Vĩnh Long', 105.9722, VungSinh.nam),
  NoiSinh('Đồng Tháp', 105.6329, VungSinh.nam),
  NoiSinh('An Giang', 105.4352, VungSinh.nam),
  NoiSinh('Kiên Giang', 105.0809, VungSinh.nam),
  NoiSinh('Cần Thơ', 105.7883, VungSinh.nam),
  NoiSinh('Hậu Giang', 105.4701, VungSinh.nam),
  NoiSinh('Sóc Trăng', 105.9719, VungSinh.nam),
  NoiSinh('Bạc Liêu', 105.7278, VungSinh.nam),
  NoiSinh('Cà Mau', 105.1524, VungSinh.nam),
];

/// Tìm nơi sinh theo tên; null nếu không có.
NoiSinh? timNoiSinh(String? ten) {
  for (final n in kNoiSinh) {
    if (n.ten == ten) return n;
  }
  return null;
}

/// Ngày dương lịch dùng lập lá số. Chỉ dịch ngày khi biết giờ:phút.
DateTime ngayLapLaSo(
    {required DateTime birthDate,
    int? gioPhut,
    String? noiSinh,
    bool tyMuonSangHomSau = false}) {
  final ngay = DateTime(birthDate.year, birthDate.month, birthDate.day);
  if (gioPhut == null) return ngay;
  final ns = timNoiSinh(noiSinh);
  if (ns == null) {
    // Không biết nơi sinh → không hiệu chỉnh múi giờ lịch sử.
    return (tyMuonSangHomSau && gioPhut >= 23 * 60)
        ? DateTime(ngay.year, ngay.month, ngay.day + 1)
        : ngay;
  }
  return chuanHoaGioSinh(
          DateTime(ngay.year, ngay.month, ngay.day, gioPhut ~/ 60, gioPhut % 60),
          vung: ns.vung,
          kinhDo: ns.kinhDo,
          tyMuonSangHomSau: tyMuonSangHomSau)
      .ngayLapLaSo;
}
