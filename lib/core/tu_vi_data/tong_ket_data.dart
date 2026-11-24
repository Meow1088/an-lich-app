/// Dữ liệu DIỄN GIẢI tử vi: đặc tính tổng kết theo 14 chính tinh.
///
/// Dùng cho phần "Tổng kết" (điểm mạnh / điểm yếu / nghề hợp). Tên chính tinh
/// KHỚP catalog `tu_vi.dart` (vd 'Thái Dương' hoa chữ D). Nội dung tử vi cổ
/// truyền phổ biến, mang tính THAM KHẢO, có nhiều dị bản.
library;

/// Điểm mạnh theo chính tinh tọa Mệnh.
const Map<String, List<String>> menhDiemManh = {
  'Tử vi': ['Có khí chất lãnh đạo', 'Chí hướng lớn', 'Được người nể trọng'],
  'Thiên cơ': ['Thông minh, mưu trí', 'Linh hoạt, thích nghi nhanh', 'Ham học hỏi'],
  'Thái Dương': ['Nhiệt tình, hào phóng', 'Thẳng thắn', 'Sẵn lòng gánh vác'],
  'Vũ khúc': ['Quyết đoán', 'Giỏi tiền bạc', 'Ý chí mạnh mẽ'],
  'Thiên đồng': ['Ôn hòa, dễ gần', 'Lạc quan', 'Có phúc, biết hưởng'],
  'Liêm trinh': ['Giàu nghị lực', 'Có nguyên tắc', 'Đa tài'],
  'Thiên phủ': ['Chín chắn', 'Biết tích lũy', 'Ổn định, đáng tin'],
  'Thái âm': ['Tinh tế, giàu tình cảm', 'Óc thẩm mỹ', 'Chu đáo'],
  'Tham lang': ['Đa tài đa nghệ', 'Giao tế giỏi', 'Nắm bắt cơ hội nhanh'],
  'Cự môn': ['Khẩu tài, lý luận sắc', 'Giỏi nghiên cứu', 'Sâu sắc'],
  'Thiên tướng': ['Trung hậu, công bằng', 'Đáng tin cậy', 'Biết giúp người'],
  'Thiên lương': ['Chính trực, nhân hậu', 'Có tài giải nạn', 'Chững chạc'],
  'Thất sát': ['Quả cảm, bản lĩnh', 'Độc lập', 'Dám nghĩ dám làm'],
  'Phá quân': ['Dám đổi mới', 'Gan dạ', 'Không ngại làm lại'],
};

/// Điểm cần lưu ý theo chính tinh tọa Mệnh.
const Map<String, List<String>> menhDiemYeu = {
  'Tử vi': ['Dễ độc đoán, sĩ diện', 'Cần người phò tá mới phát huy'],
  'Thiên cơ': ['Hay thay đổi', 'Lo nghĩ nhiều, thiếu kiên định'],
  'Thái Dương': ['Dễ hao tâm vì người', 'Nóng tính, hay ôm đồm'],
  'Vũ khúc': ['Khô khan trong tình cảm', 'Đôi khi cứng nhắc'],
  'Thiên đồng': ['Thiếu nghị lực, ưa an nhàn', 'Ngại va chạm'],
  'Liêm trinh': ['Cố chấp', 'Cảm xúc mạnh, dễ thị phi'],
  'Thiên phủ': ['Thủ cựu, ngại mạo hiểm', 'Đôi khi quá tính toán'],
  'Thái âm': ['Hay ưu tư, nhạy cảm', 'Thiếu quyết đoán'],
  'Tham lang': ['Ham muốn nhiều, dễ sa đà', 'Khó tập trung lâu'],
  'Cự môn': ['Hay thị phi, đa nghi', 'Lời nói dễ mất lòng'],
  'Thiên tướng': ['Cả nể, thiếu chủ kiến', 'Trọng hình thức'],
  'Thiên lương': ['Bảo thủ', 'Hay lo xa, thích dạy đời'],
  'Thất sát': ['Nóng vội', 'Dễ cô độc, đời thăng trầm'],
  'Phá quân': ['Bốc đồng', 'Khó an phận, nhiều biến động'],
};

/// Nghề nghiệp hợp theo chính tinh (ưu tiên tọa Quan lộc, fallback Mệnh).
const Map<String, List<String>> ngheTheoChinhTinh = {
  'Tử vi': ['Quản lý', 'Lãnh đạo', 'Hành chính cấp cao'],
  'Thiên cơ': ['Tư vấn', 'Kế hoạch', 'Kỹ thuật', 'Nghiên cứu'],
  'Thái Dương': ['Giáo dục', 'Truyền thông', 'Chính trị', 'Công ích'],
  'Vũ khúc': ['Tài chính', 'Kinh doanh', 'Kỹ thuật', 'Quân đội'],
  'Thiên đồng': ['Dịch vụ', 'Sáng tạo', 'Phúc lợi', 'Chăm sóc'],
  'Liêm trinh': ['Hành chính', 'Kỹ thuật', 'Nghệ thuật', 'Kỷ luật'],
  'Thiên phủ': ['Quản lý', 'Tài chính', 'Kho quỹ', 'Hành chính'],
  'Thái âm': ['Tài sản', 'Văn hóa', 'Làm đẹp', 'Chăm sóc'],
  'Tham lang': ['Kinh doanh', 'Giao tế', 'Giải trí', 'Ngoại giao'],
  'Cự môn': ['Luật', 'Giáo dục', 'Báo chí', 'Y', 'Diễn thuyết'],
  'Thiên tướng': ['Tham mưu', 'Đối ngoại', 'Hành chính', 'Thư ký'],
  'Thiên lương': ['Y dược', 'Giáo dục', 'Pháp luật', 'Từ thiện'],
  'Thất sát': ['Quân đội', 'Kỹ thuật nặng', 'Khai phá', 'Kinh doanh mạo hiểm'],
  'Phá quân': ['Cải cách', 'Khởi nghiệp', 'Kỹ thuật', 'Nghề thay đổi'],
};
