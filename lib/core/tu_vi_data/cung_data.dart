/// Dữ liệu DIỄN GIẢI tử vi: 12 cung chức + Ngũ hành Cục + nhãn giờ.
///
/// Tách khỏi engine an sao (`tu_vi.dart`) và logic luận (`tu_vi_dien_giai.dart`)
/// để dễ bảo trì khi nội dung lớn dần. Nội dung THAM KHẢO, có nhiều dị bản.
library;

/// Nhãn 12 giờ địa chi + khung giờ dương.
const List<String> gioLabels = [
  'Tý (23h–1h)',
  'Sửu (1h–3h)',
  'Dần (3h–5h)',
  'Mão (5h–7h)',
  'Thìn (7h–9h)',
  'Tỵ (9h–11h)',
  'Ngọ (11h–13h)',
  'Mùi (13h–15h)',
  'Thân (15h–17h)',
  'Dậu (17h–19h)',
  'Tuất (19h–21h)',
  'Hợi (21h–23h)',
];

/// Ý nghĩa của Ngũ hành Cục.
String cucYNghia(int cuc) {
  switch (cuc) {
    case 2:
      return 'Thủy nhị Cục — khởi vận sớm, tính cách mềm dẻo, linh hoạt, '
          'thích ứng nhanh.';
    case 3:
      return 'Mộc tam Cục — ôn hòa, nhân hậu, vươn lên bền bỉ như cây cối.';
    case 4:
      return 'Kim tứ Cục — cương nghị, quyết đoán, coi trọng nguyên tắc.';
    case 5:
      return 'Thổ ngũ Cục — vững vàng, thực tế, chịu khó, hậu vận tốt dần.';
    case 6:
      return 'Hỏa lục Cục — nhiệt huyết, nhanh nhẹn, dễ thành công nhờ '
          'năng nổ nhưng cần tiết chế nóng vội.';
    default:
      return '';
  }
}

/// Ý nghĩa 12 cung chức.
const Map<String, String> yNghiaCung = {
  'Mệnh': 'Bản thân, tính cách cốt lõi, vận mệnh tổng quát của cả đời.',
  'Phụ mẫu': 'Cha mẹ, bề trên, cấp trên và mối quan hệ với họ.',
  'Phúc đức': 'Phúc phần, hưởng thụ tinh thần, tâm tính và may mắn nền tảng.',
  'Điền trạch': 'Nhà cửa, đất đai, tài sản cố định và môi trường sống.',
  'Quan lộc': 'Sự nghiệp, công danh, học hành, vị thế xã hội.',
  'Nô bộc': 'Bạn bè, đồng nghiệp, người giúp việc, các mối quan hệ ngang hàng.',
  'Thiên di': 'Đi xa, ra ngoài xã hội, cơ hội và quan hệ nơi xa.',
  'Tật ách': 'Sức khỏe, bệnh tật, tai ách và thể chất.',
  'Tài bạch': 'Tiền bạc, cách kiếm tiền, khả năng quản lý tài chính.',
  'Tử tức': 'Con cái, hậu duệ và quan hệ với con.',
  'Phu thê': 'Hôn nhân, vợ/chồng, tình duyên và đời sống lứa đôi.',
  'Huynh đệ': 'Anh chị em, cộng sự thân thiết, người đồng hành.',
};
