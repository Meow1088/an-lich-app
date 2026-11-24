/// Dữ liệu DIỄN GIẢI tử vi: BỘ SAO (chính tinh đi cặp cùng cung) + CÁCH CỤC
/// (nhóm tinh hệ) + ĐỐI CUNG (xung chiếu).
///
/// Tên sao KHỚP catalog `tu_vi.dart` ('Thái Dương' hoa D). Nội dung tử vi cổ
/// truyền phổ biến, THAM KHẢO, nhiều dị bản.
library;

/// Diễn giải khi hai chính tinh cùng tọa một cung (bộ sao kinh điển).
/// Tra cứu thử cả 2 thứ tự "A|B" và "B|A".
const Map<String, String> boSaoCap = {
  'Tử vi|Thiên phủ':
      'hai sao đế hội tụ — rất ổn định, có quý cách, giỏi tổ chức và quản lý; '
          'cuộc sống sung túc, hợp vị trí đứng đầu.',
  'Tử vi|Tham lang':
      'uy quyền pha hưởng thụ — giỏi giao tế, đa tài, ham vui; thành công nhờ '
          'quan hệ nhưng cần tiết chế dục vọng.',
  'Tử vi|Thiên tướng':
      'vua có tể tướng phò — đường hoàng, biết dùng người, hợp quản lý và vai '
          'trò trung tâm; đời tương đối thuận.',
  'Tử vi|Thất sát':
      'hóa khí thành quyền — uy mãnh, quyết đoán, có khí phách thủ lĩnh; làm '
          'lớn được nhưng tính cương, dễ áp lực.',
  'Tử vi|Phá quân':
      'quyền uy pha phá cách — dám cải tổ, mạnh mẽ, không theo lối mòn; đời '
          'nhiều biến động, hợp khai phá.',
  'Liêm trinh|Thiên phủ':
      'nghị lực cộng biết tích lũy — làm ăn bài bản, kỷ luật, tài chính ổn; '
          'hợp quản trị, hành chính.',
  'Liêm trinh|Tham lang':
      'đa tình đa tài — giao tế giỏi, đào hoa, ham vui; dễ vướng tình/tiền '
          'nếu không tiết chế.',
  'Liêm trinh|Thiên tướng':
      'có nguyên tắc cộng công bằng — đáng tin, hợp vai chấp pháp, quản lý '
          'quy củ.',
  'Liêm trinh|Thất sát':
      'cương mãnh quyết liệt — bản lĩnh, dám xông pha; đời thăng trầm, hợp '
          'nghề cứng, cần kiềm chế nóng nảy.',
  'Liêm trinh|Phá quân':
      'mạnh mẽ phá cách — dám làm dám chịu, hay thay đổi; thành bại rõ, hợp '
          'khởi nghiệp/cải cách.',
  'Vũ khúc|Thiên phủ':
      'hai tài tinh — rất giỏi kiếm và giữ tiền, thực tế; tài chính là điểm '
          'mạnh, hợp kinh doanh, ngân hàng.',
  'Vũ khúc|Tham lang':
      'tài cộng giao tế — kiếm tiền giỏi qua quan hệ, thường phát muộn mà bền '
          '(tài đến sau tuổi trung niên).',
  'Vũ khúc|Thiên tướng':
      'cương quyết cộng chừng mực — hợp tài chính, kỹ thuật bài bản; đáng tin, '
          'có thực quyền.',
  'Vũ khúc|Thất sát':
      'quyết đoán cộng cứng rắn — ý chí sắt đá, hợp nghề mạnh tay; tình cảm '
          'khô, dễ lao lực.',
  'Vũ khúc|Phá quân':
      'cương cộng phá — dám đầu tư lớn, hay làm lại; tài lộc biến động mạnh, '
          'cần quản trị rủi ro.',
  'Thái Dương|Thái âm':
      'Nhật Nguyệt — tình cảm phong phú, vừa hướng ngoại vừa tinh tế; sáng tối '
          'tùy vị trí, hợp việc cân bằng.',
  'Thái Dương|Cự môn':
      'Cự Nhật — khẩu tài cộng danh tiếng, hợp nghề nói/dạy/luật/ngoại giao; '
          'nói có sức nặng nhưng dễ thị phi.',
  'Thái Dương|Thiên lương':
      'quang minh cộng chính trực — hợp giáo dục, giám sát, từ thiện; được '
          'kính trọng, hay lo cho người.',
  'Thiên cơ|Thái âm':
      'mưu trí cộng tinh tế — đầu óc nhạy, hợp kế hoạch, tài chính, sáng tạo; '
          'hơi đa cảm, hay đổi ý.',
  'Thiên cơ|Cự môn':
      'trí cộng khẩu — giỏi phân tích, lý luận, nghiên cứu, đàm phán; cẩn thận '
          'lời nói kẻo thị phi.',
  'Thiên cơ|Thiên lương':
      'mưu lược cộng chính trực — chất quân sư, cố vấn, giỏi hóa giải; nguyên '
          'tắc, đôi khi hay bàn lùi.',
  'Thiên đồng|Cự môn':
      'ôn hòa cộng khẩu tài — dễ chịu nhưng hay tâm sự/than; hợp dịch vụ, tư '
          'vấn, ẩm thực.',
  'Thiên đồng|Thiên lương':
      'phúc cộng ấm — hiền hòa, có quý nhân, an nhàn hưởng phúc; hợp việc nhẹ '
          'nhàng, chăm sóc.',
  'Thiên đồng|Thái âm':
      'phúc cộng tình — dịu dàng, lãng mạn, ưa cái đẹp; đời sống tình cảm '
          'phong phú, hơi thiếu quyết đoán.',
};

/// Thành viên các nhóm tinh hệ (cách cục).
const Map<String, List<String>> cachCucThanhVien = {
  'Tử Phủ Vũ Tướng': ['Tử vi', 'Thiên phủ', 'Vũ khúc', 'Thiên tướng', 'Liêm trinh'],
  'Sát Phá Tham': ['Thất sát', 'Phá quân', 'Tham lang'],
  'Cơ Nguyệt Đồng Lương': ['Thiên cơ', 'Thái âm', 'Thiên đồng', 'Thiên lương'],
  'Cự Nhật': ['Cự môn', 'Thái Dương'],
};

/// Ý nghĩa từng cách cục.
const Map<String, String> cachCucYNghia = {
  'Tử Phủ Vũ Tướng': 'nhóm ổn định – quản trị: thiên về tổ chức, tài chính, '
      'giữ nền nếp; hợp lãnh đạo/quản lý, đời tương đối vững.',
  'Sát Phá Tham': 'nhóm khai phá – biến động: mạnh mẽ, dám thay đổi, thích '
      'chinh phục; đời nhiều thăng trầm nhưng bản lĩnh, hợp khởi nghiệp/cạnh tranh.',
  'Cơ Nguyệt Đồng Lương': 'nhóm trí tuệ – ôn hòa: thông minh, tình cảm, ưa ổn '
      'định và chuyên môn; hợp nghiên cứu, kế hoạch, giáo dục, chăm sóc.',
  'Cự Nhật': 'nhóm ngôn luận – truyền bá: giỏi ăn nói, lý luận, lan tỏa; hợp '
      'giảng dạy, truyền thông, luật, ngoại giao.',
};

/// Đối cung (xung chiếu) theo tên cung chức.
const Map<String, String> doiCung = {
  'Mệnh': 'Thiên di',
  'Thiên di': 'Mệnh',
  'Phụ mẫu': 'Tật ách',
  'Tật ách': 'Phụ mẫu',
  'Phúc đức': 'Tài bạch',
  'Tài bạch': 'Phúc đức',
  'Điền trạch': 'Tử tức',
  'Tử tức': 'Điền trạch',
  'Quan lộc': 'Phu thê',
  'Phu thê': 'Quan lộc',
  'Nô bộc': 'Huynh đệ',
  'Huynh đệ': 'Nô bộc',
};
