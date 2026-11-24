/// Giải thích thuật ngữ bằng ngôn ngữ đời thường (cho popup dấu "?").
library;

const Map<String, String> glossary = {
  'hoang_dao':
      'Ngày Hoàng đạo là ngày có sao tốt cai quản — được xem là thuận lợi để làm việc quan trọng như cưới hỏi, khai trương, xuất hành. Ngày Hắc đạo thì ngược lại, người xưa khuyên tránh việc lớn. Đây là quan niệm dân gian, mang tính tham khảo.',
  'truc':
      'Mỗi ngày ứng với 1 trong 12 "Trực" (Kiến, Trừ, Mãn, Bình, Định, Chấp, Phá, Nguy, Thành, Thu, Khai, Bế) — như 12 trạng thái luân phiên của vạn vật. Mỗi Trực hợp làm một số việc và nên kiêng một số việc khác.',
  'sao':
      '28 Sao (Nhị thập bát tú) là 28 chòm sao luân phiên cai quản mỗi ngày, chia thành sao tốt (cát) và sao xấu (hung) theo quan niệm cổ truyền. Mỗi sao còn ứng với một "thất diệu" (Nhật, Nguyệt, Hỏa, Thủy, Mộc, Kim, Thổ).',
  'can_chi':
      'Can Chi là cách gọi tên ngày/tháng/năm bằng cách ghép 10 Thiên Can (Giáp, Ất, Bính...) với 12 Địa Chi (Tý, Sửu, Dần...), lặp lại theo chu kỳ 60. Ví dụ: năm Nhâm Tý, ngày Tân Mùi.',
  'nap_am':
      'Nạp âm là ngũ hành (Kim, Mộc, Thủy, Hỏa, Thổ) gắn với từng cặp Can Chi, cho biết "mệnh". Ví dụ tuổi Nhâm Tý thuộc mệnh Tang Đố Mộc (Mộc).',
  'tiet_khi':
      'Tiết khí là 24 mốc chia một năm theo vị trí mặt trời, phản ánh thời tiết và mùa vụ (Lập Xuân, Thanh Minh, Hạ Chí, Đông Chí...). Dùng nhiều trong nông lịch.',
  'gio_hoang_dao':
      'Giờ hoàng đạo là những khung giờ tốt trong ngày (mỗi giờ ứng 2 tiếng), được cho là thuận lợi để khởi sự việc quan trọng. Trong ngày thường có vài giờ hoàng đạo.',
  'tu_vi_ngay':
      'Tử vi hằng ngày ở đây được tính từ tuổi (can chi, mệnh ngũ hành) của bạn kết hợp với tính chất của ngày và nhịp sinh học. Đây là thông tin tham khảo/giải trí, không phải lời tiên đoán chắc chắn.',
};

/// Lấy giải thích; trả chuỗi rỗng nếu không có.
String explain(String key) => glossary[key] ?? '';
