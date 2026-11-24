/// Dữ liệu "luận theo tuổi" cho chế độ 📖 Dễ hiểu (KHÔNG cần giờ sinh).
///
/// Chỉ dùng thông tin từ NĂM sinh: con giáp (chi năm), bản mệnh (nạp âm ngũ
/// hành) và Tứ Hóa của năm. Nội dung cổ truyền phổ biến, mang tính THAM KHẢO /
/// tín ngưỡng dân gian — có nhiều dị bản.
library;

/// Con vật 12 con giáp (index theo địa chi 0=Tý .. 11=Hợi).
const List<String> conGiapConVat = [
  'Chuột', 'Trâu', 'Hổ', 'Mèo', 'Rồng', 'Rắn',
  'Ngựa', 'Dê', 'Khỉ', 'Gà', 'Chó', 'Lợn',
];

/// Từ khóa lĩnh vực ngắn cho các sao có thể mang Tứ Hóa (để luận theo tuổi).
const Map<String, String> saoTuKhoa = {
  'Tử vi': 'lãnh đạo, uy tín',
  'Liêm trinh': 'nghị lực, kỷ luật',
  'Thiên đồng': 'phúc khí, an nhàn',
  'Vũ khúc': 'tài chính, hành động',
  'Thái Dương': 'sự nghiệp, danh tiếng',
  'Thiên cơ': 'tư duy, mưu trí',
  'Thiên phủ': 'tích lũy, ổn định',
  'Thái âm': 'tài sản, nội tâm',
  'Tham lang': 'giao tế, đam mê',
  'Cự môn': 'ăn nói, nghiên cứu',
  'Thiên lương': 'che chở, nguyên tắc',
  'Phá quân': 'đổi mới, khai phá',
  'Văn xương': 'học vấn, văn chương',
  'Văn Khúc': 'tài lẻ, khẩu tài',
  'Hữu bật': 'quý nhân trợ giúp',
  'Tả phù': 'quý nhân trợ giúp',
};

/// Tính cách theo 12 con giáp (index theo địa chi 0=Tý .. 11=Hợi).
const List<String> conGiapTinhCach = [
  // Tý
  'Nhanh nhẹn, thông minh, khéo xoay xở và tiết kiệm. Giỏi nắm bắt cơ hội, '
      'thích ứng tốt; đôi khi hơi tính toán và cả nể.',
  // Sửu
  'Cần cù, bền bỉ, trung thực và đáng tin. Làm việc chắc chắn, kiên trì tới '
      'cùng; hơi bảo thủ và chậm thay đổi.',
  // Dần
  'Mạnh mẽ, dũng cảm, có chí tiến thủ và tinh thần lãnh đạo. Dám nghĩ dám làm; '
      'đôi khi nóng vội, thích tự do.',
  // Mão
  'Hiền hòa, tinh tế, khéo léo trong giao tiếp và ưa cái đẹp. Ôn nhu, dễ mến; '
      'đôi khi thiếu quyết đoán, ngại va chạm.',
  // Thìn
  'Bản lĩnh, nhiều hoài bão, tự tin và có sức hút. Giàu năng lượng, thích '
      'khẳng định mình; đôi khi tự cao, ôm việc lớn.',
  // Tỵ
  'Sâu sắc, khôn ngoan, trực giác tốt và biết ẩn mình. Điềm tĩnh, mưu lược; '
      'đôi khi kín đáo, khó gần và hay đa nghi.',
  // Ngọ
  'Năng động, phóng khoáng, nhiệt tình và yêu tự do. Giao tiếp rộng, lạc quan; '
      'đôi khi bốc đồng, thiếu kiên nhẫn.',
  // Mùi
  'Dịu dàng, nhân hậu, giàu tình cảm và biết nhường nhịn. Sống thiên về gia '
      'đình; đôi khi hay lo nghĩ, thiếu tự tin.',
  // Thân
  'Lanh lợi, hoạt bát, đa tài và giỏi ứng biến. Sáng tạo, hài hước; đôi khi '
      'hiếu thắng, cả thèm chóng chán.',
  // Dậu
  'Chỉn chu, cầu toàn, chăm chỉ và có gu thẩm mỹ. Thẳng thắn, trách nhiệm; '
      'đôi khi khó tính, hay soi xét.',
  // Tuất
  'Trung thành, chính trực, sống tình nghĩa và có trách nhiệm. Đáng tin, biết '
      'bảo vệ người thân; đôi khi hay lo xa, cố chấp.',
  // Hợi
  'Thật thà, rộng lượng, hiền lành và biết hưởng thụ. Dễ chịu, có phúc; đôi '
      'khi cả tin, ngại tranh giành.',
];

/// Ý nghĩa bản mệnh theo nạp âm ngũ hành.
const Map<String, String> nguHanhBanMenh = {
  'Kim': 'Người mệnh Kim thường cương nghị, quyết đoán, trọng nguyên tắc và có '
      'ý chí. Hợp việc cần kỷ luật, tài chính, kỹ thuật.',
  'Mộc': 'Người mệnh Mộc thường nhân hậu, vươn lên, thích phát triển và sáng '
      'tạo. Hợp việc nuôi dưỡng, giáo dục, xây dựng lâu dài.',
  'Thủy': 'Người mệnh Thủy thường linh hoạt, thông minh, giao tiếp khéo và dễ '
      'thích nghi. Hợp việc di chuyển, kết nối, buôn bán.',
  'Hỏa': 'Người mệnh Hỏa thường nhiệt tình, sôi nổi, quyết liệt và có sức hút. '
      'Hợp việc dẫn dắt, truyền cảm hứng, sáng tạo.',
  'Thổ': 'Người mệnh Thổ thường điềm đạm, chắc chắn, đáng tin và bao dung. Hợp '
      'việc quản lý, tích lũy, chăm lo nền tảng.',
};

/// Ý nghĩa 4 Hóa (đời thường, dùng cho luận theo tuổi).
const Map<String, String> yNghiaHoa = {
  'Hóa lộc': 'được trợ lực về tài lộc và cơ hội — dễ gặp may, thuận về tiền '
      'bạc và quan hệ',
  'Hóa quyền': 'được tăng sức mạnh và quyền chủ động — quyết đoán, dễ nắm vai '
      'trò dẫn dắt, thăng tiến',
  'Hóa khoa': 'được nâng về danh tiếng và quý nhân — thuận học hành, thi cử, '
      'tiếng tốt và người giúp',
  'Hóa kỵ': 'dễ vướng mắc, hao tổn ở lĩnh vực này — nên thận trọng, kiên nhẫn '
      'và tránh nóng vội',
};

/// Nhãn nhóm cho Hóa (tốt / cần lưu ý).
bool hoaLaTot(String hoa) => hoa != 'Hóa kỵ';
