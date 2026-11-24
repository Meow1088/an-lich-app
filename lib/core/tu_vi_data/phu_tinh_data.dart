/// Dữ liệu DIỄN GIẢI tử vi: ý nghĩa PHỤ TINH / SÁT TINH / ĐÀO HOA / tài lộc.
///
/// Tên sao KHỚP catalog trong `tu_vi.dart` (vd 'Văn Khúc' viết hoa chữ K).
/// Nội dung tử vi cổ truyền phổ biến, viết ngắn gọn đời thường, mang tính
/// THAM KHẢO / tín ngưỡng, có nhiều dị bản giữa các phái.
library;

/// Ý nghĩa ngắn của từng phụ/sát tinh (1 câu).
const Map<String, String> phuTinhYNghia = {
  // — Lục cát + trợ tinh (cát) —
  'Tả phù': 'quý nhân ngầm nâng đỡ, có người trợ giúp phía sau.',
  'Hữu bật': 'có cộng sự, người giúp việc tận tâm, thêm vây cánh.',
  'Văn xương': 'thông minh, học hành, văn chương, thi cử thuận lợi.',
  'Văn Khúc': 'tài hoa, ăn nói khéo, hợp nghệ thuật và ngoại giao.',
  'Văn tinh': 'sao văn chương, hỗ trợ học vấn, chữ nghĩa.',
  'Thiên khôi': 'quý nhân bậc trên đề bạt, giúp đỡ đúng lúc.',
  'Thiên việt': 'quý nhân, ân nhân xuất hiện bất ngờ giúp đỡ.',
  'Lộc tồn': 'tài lộc ổn định, có của ăn của để, hưởng phúc lộc.',
  'Thiên mã': 'năng động, hay đi lại, dịch chuyển; gặp Lộc thì phát đạt.',
  'Quốc ấn': 'có quyền chức, được giao trọng trách, uy tín.',
  'Tam thai': 'có địa vị, được tôn trọng, phong thái đường hoàng.',
  'Bát tọa': 'có chỗ đứng, được nể vì; đi cùng Tam thai càng quý.',
  'Ân quang': 'được ban ơn, khen thưởng, quý nhân chiếu cố.',
  'Thiên quý': 'cao quý, được trọng vọng, có tiếng tốt.',
  'Long trì': 'khoa giáp, công danh vẻ vang (cặp với Phượng các).',
  'Phượng các': 'tài năng, dung mạo, danh tiếng (cặp với Long trì).',
  'Thai phụ': 'hỗ trợ thi cử, bằng cấp, quý nhân về văn.',
  'Phong cáo': 'giấy tờ, bằng sắc thuận lợi (cặp với Thai phụ).',
  'Thiên quan': 'quý nhân che chở, có chức phận.',
  'Thiên phúc': 'phúc lộc, được hưởng, hóa giải bớt điều xấu.',
  'Thiên đức': 'sao đức, hóa giải tai ách, tăng phúc.',
  'Nguyệt đức': 'sao đức, thêm phúc, giảm nhẹ điều hung.',
  'Long đức': 'cát tinh, hóa giải, gặp may trong rủi.',
  'Phúc đức': 'phúc phần, hưởng thụ, tâm an.',
  'Thiên thọ': 'trường thọ, sức khỏe bền, tính điềm đạm.',
  'Thiên y': 'hợp y dược, hay giúp người; quý nhân về sức khỏe.',
  'Thiên trù': 'ăn uống đầy đủ, có lộc ăn, hợp ẩm thực.',
  'Thiên tài': 'khéo về tiền bạc, có chút năng khiếu tài chính.',
  'Thiên giải': 'sao hóa giải, giảm nhẹ tai ách.',
  'Địa giải': 'sao hóa giải, tai qua nạn khỏi.',
  'Giải thần': 'hóa giải khó khăn, chuyện dữ hóa lành.',
  'Hỷ thần': 'tin vui, hỷ sự, niềm vui đến.',
  'Thanh long': 'hanh thông, có tài lộc và tin mừng.',
  'Tấu thư': 'giấy tờ, tin tức, văn thư thuận lợi.',
  'Tướng quân': 'uy quyền, mạnh mẽ, có khí thế chỉ huy.',
  'Lực sĩ': 'sức lực, có chút quyền, năng nổ.',
  'Bác sỹ': 'thông minh, có học, khéo léo.',
  'Đường phù': 'hỗ trợ công danh, giấy tờ thuận.',

  // — Đào hoa / tình duyên —
  'Đào hoa': 'duyên dáng, hấp dẫn người khác phái, dễ có người theo.',
  'Hồng loan': 'hỷ sự hôn nhân, cưới hỏi, tình duyên đẹp.',
  'Thiên hỷ': 'tin vui, hỷ sự, con cái, niềm vui.',
  'Mộc dục': 'phong lưu, đa tình, ưa cái đẹp (sao đào hoa).',

  // — Lục sát + hung tinh (cần lưu ý) —
  'Kình dương': 'tính nóng, quyết liệt, dễ va chạm, đề phòng thương tật.',
  'Đà la': 'trì trệ, vướng mắc kéo dài, phiền muộn ngấm ngầm.',
  'Hỏa tinh': 'nóng nảy, bộc phát; gặp cát thì uy, gặp hung dễ tai nạn.',
  'Linh tinh': 'âm ỉ, bất ngờ, hay lo lắng (giống Hỏa nhưng ngầm).',
  'Địa không': 'hao hụt, mộng tưởng, dễ mất mát, suy nghĩ khác người.',
  'Địa kiếp': 'phá tán, thất thoát tiền của, làm rồi dễ mất.',
  'Kiếp sát': 'tai họa bất ngờ, mất mát, cần đề phòng.',
  'Thiên hình': 'cương khắc, kỷ luật; dễ kiện tụng/thương tật, hợp luật–y.',
  'Thiên riêu': 'đa tình, dễ thị phi tình cảm, chuyện riêng tư.',
  'Thiên khốc': 'u buồn, hay ưu tư, dễ xúc động.',
  'Thiên hư': 'trống trải, hao hư, sức khỏe dễ yếu.',
  'Cô thần': 'cô đơn, lạnh lùng, ít gần gũi.',
  'Quả tú': 'lẻ loi, tình duyên dễ muộn màng.',
  'Đại hao': 'hao tốn lớn, dễ chi mất khoản nhiều.',
  'Tiểu hao': 'hao vặt, rò rỉ tiền bạc lặt vặt.',
  'Phá toái': 'đổ vỡ, dang dở, hay hỏng việc nhỏ.',
  'Thiên thương': 'tổn thương, mất mát, hao tổn.',
  'Thiên sứ': 'tai ách bất ngờ, bệnh tật thoáng qua.',
  'Thiên la': 'như lưới trời — bị giam hãm, trở ngại khó bung.',
  'Địa võng': 'như lưới đất — vướng víu, khó thoát ra.',
  'Tang môn': 'tang chế, buồn phiền, hao người thân.',
  'Bạch hổ': 'tang thương, kiện tụng, đề phòng tai nạn.',
  'Quan phù': 'thị phi, kiện tụng, vướng pháp lý.',
  'Tuế phá': 'xung Thái Tuế, hao tổn, trục trặc trong năm.',
  'Điếu khách': 'thị phi, lời ra tiếng vào, phiền nhiễu.',
  'Phục binh': 'tiểu nhân rình rập, dễ bị hãm ngầm.',
  'Phi liêm': 'thị phi, tiếng xấu lan nhanh.',
  'Bệnh phù': 'đau ốm vặt, sức khỏe sa sút.',
  'Lưu hà': 'trắc trở, tai tiếng, hao tán.',
  'Thiên không': 'hư không, ý tưởng bay bổng, dễ hụt hẫng.',
  'Hoa cái': 'tài hoa nhưng cô cao, thích tâm linh/nghệ thuật.',
};

/// Các sao mang tính bất lợi (để phân cực tốt/xấu khi trình bày).
const Set<String> saoCanLuuY = {
  'Kình dương', 'Đà la', 'Hỏa tinh', 'Linh tinh', 'Địa không', 'Địa kiếp',
  'Kiếp sát', 'Thiên hình', 'Thiên riêu', 'Thiên khốc', 'Thiên hư', 'Cô thần',
  'Quả tú', 'Đại hao', 'Tiểu hao', 'Phá toái', 'Thiên thương', 'Thiên sứ',
  'Thiên la', 'Địa võng', 'Tang môn', 'Bạch hổ', 'Quan phù', 'Tuế phá',
  'Điếu khách', 'Phục binh', 'Phi liêm', 'Bệnh phù', 'Lưu hà', 'Thiên không',
};

/// Ý nghĩa phụ tinh (null nếu sao chưa có dữ liệu).
String? yNghiaPhuTinh(String ten) => phuTinhYNghia[ten];

/// Sao có nằm trong nhóm cần lưu ý (bất lợi) không.
bool laSaoCanLuuY(String ten) => saoCanLuuY.contains(ten);
