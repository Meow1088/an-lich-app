/// Dữ liệu DIỄN GIẢI tử vi: 14 chính tinh.
///
/// - [chinhTinhTinhChat]: tính chất chung (dùng cho cung chưa có lớp sâu).
/// - 5 map lớp SÂU theo cung trọng yếu (Mệnh / Tài bạch / Quan lộc / Phu thê /
///   Phúc đức) — mỗi map đủ 14 chính tinh.
///
/// Nội dung tử vi cổ truyền phổ biến, mang tính THAM KHẢO, có nhiều dị bản.
library;

/// Tính chất tổng quát của 14 chính tinh.
const Map<String, String> chinhTinhTinhChat = {
  'Tử vi': 'Đế tinh — uy quyền, lãnh đạo, cao quý. Người có chí lớn, '
      'thích chỉ huy, ưa được tôn trọng; cần có sao phò tá mới phát huy.',
  'Thiên cơ': 'Sao mưu trí — thông minh, khéo léo, giỏi tính toán và '
      'thích ứng. Nhanh nhạy nhưng dễ thay đổi, hay suy nghĩ.',
  'Thái Dương': 'Sao mặt trời — quang minh, nhiệt tình, bác ái, thích cho đi. '
      'Sáng sủa khi đắc địa (ban ngày), mờ nhạt khi hãm.',
  'Vũ khúc': 'Tài tinh — cương trực, quyết đoán, giỏi tài chính, hành động. '
      'Ý chí mạnh, hợp kinh doanh, quân sự; tình cảm hơi khô khan.',
  'Thiên đồng': 'Phúc tinh — hiền hòa, lạc quan, hưởng phúc, dễ chịu. '
      'Ưa an nhàn, tình cảm phong phú nhưng đôi khi thiếu nghị lực.',
  'Liêm trinh': 'Sao thứ đào hoa kiêm quan lộc — cương cường, có phép tắc, '
      'giàu nghị lực; đa diện, lúc chính trực lúc phong lưu.',
  'Thiên phủ': 'Kho tài — ổn định, bao dung, biết tích lũy, cẩn trọng. '
      'Người đôn hậu, giỏi quản lý, trọng vật chất và sự an toàn.',
  'Thái âm': 'Sao mặt trăng — dịu dàng, tinh tế, giàu tình cảm, ưa cái đẹp. '
      'Sáng khi đắc (ban đêm), chủ tài sản và mẹ/vợ.',
  'Tham lang': 'Sao đào hoa — đa tài đa nghệ, ham muốn mạnh, giao tế giỏi. '
      'Linh hoạt, thích hưởng thụ, dục vọng và tham vọng đều lớn.',
  'Cự môn': 'Ám tinh — khẩu tài, lý luận sắc bén, giỏi nghiên cứu/phản biện. '
      'Nói năng có sức nặng nhưng dễ thị phi, hay hoài nghi.',
  'Thiên tướng': 'Ấn tinh — trung hậu, công bằng, thích giúp người, trọng '
      'hình thức và lễ nghĩa. Hợp vai phụ tá, tham mưu.',
  'Thiên lương': 'Ấm tinh — chính trực, từ thiện, có khả năng hóa giải tai ách. '
      'Người lớn tuổi trước tuổi, thích chở che, ưa nguyên tắc.',
  'Thất sát': 'Tướng tinh — uy mãnh, quả cảm, độc lập, dám nghĩ dám làm. '
      'Khí phách mạnh mẽ, đời nhiều thăng trầm, hợp khai phá.',
  'Phá quân': 'Hao tinh — phá cách, đổi mới, dũng cảm, không theo lề lối. '
      'Thích thay đổi, làm lại, cuộc đời nhiều biến động lớn.',
};

/// Diễn giải khi mỗi chính tinh TỌA CUNG MỆNH (lớp "sâu" cho cung Mệnh).
const Map<String, String> menhChinhTinh = {
  'Tử vi': 'Mệnh Tử vi: cốt cách lãnh đạo, tự tôn, có chí hướng và phong thái '
      'đường bệ. Dễ được người nể trọng, hợp vị trí đứng đầu; cần Tả Hữu, '
      'Xương Khúc phò tá để tránh cô độc, độc đoán.',
  'Thiên cơ': 'Mệnh Thiên cơ: trí tuệ linh hoạt, mưu lược, giỏi tính toán và '
      'thích học hỏi. Thành công nhờ đầu óc; nên kiên định để bớt thay đổi, '
      'lo nghĩ.',
  'Thái Dương': 'Mệnh Thái Dương: hào phóng, nhiệt thành, thẳng thắn, thích '
      'gánh vác. Đắc địa thì danh tiếng rạng rỡ; hãm địa thì vất vả, dễ '
      'hao tâm vì người khác.',
  'Vũ khúc': 'Mệnh Vũ khúc: ý chí sắt đá, quyết đoán, giỏi kiếm tiền và hành '
      'động. Hợp tài chính, kinh doanh; nên mềm mỏng hơn trong tình cảm.',
  'Thiên đồng': 'Mệnh Thiên đồng: ôn hòa, lạc quan, có phúc, dễ gần. Cuộc đời '
      'thường hanh thông về sau; cần thêm nghị lực để không ỷ lại an nhàn.',
  'Liêm trinh': 'Mệnh Liêm trinh: cá tính mạnh, có nguyên tắc, giàu nghị lực, '
      'đa tài. Thành bại rõ rệt; gặp sao tốt thì quý hiển, gặp sát tinh '
      'thì dễ thị phi.',
  'Thiên phủ': 'Mệnh Thiên phủ: đôn hậu, chín chắn, biết lo xa và tích lũy. '
      'Cuộc sống ổn định, sung túc; hợp quản lý, tài chính, hành chính.',
  'Thái âm': 'Mệnh Thái âm: tình cảm, tinh tế, ưa cái đẹp, có duyên ngầm. '
      'Đắc địa chủ giàu có, được quý nhân nữ giúp; hãm thì hay ưu tư.',
  'Tham lang': 'Mệnh Tham lang: đa tài, giao thiệp rộng, ham muốn và tham vọng '
      'lớn. Nhiều cơ hội nhưng dễ sa đà; biết tiết chế thì phát đạt.',
  'Cự môn': 'Mệnh Cự môn: khẩu tài, lý luận giỏi, hợp nghề dùng lời nói/nghiên '
      'cứu. Dễ vướng thị phi, hiểu lầm; cần thận trọng lời ăn tiếng nói.',
  'Thiên tướng': 'Mệnh Thiên tướng: trung thực, công bằng, thích giúp người, '
      'trọng lễ nghĩa. Hợp vai tham mưu, phụ tá đắc lực, được tin cậy.',
  'Thiên lương': 'Mệnh Thiên lương: chính trực, nhân từ, có khả năng giải nạn, '
      'già dặn sớm. Hợp y dược, giáo dục, pháp luật; đôi khi hơi bảo thủ.',
  'Thất sát': 'Mệnh Thất sát: cương nghị, dũng mãnh, độc lập, dám xông pha. '
      'Đời nhiều thăng trầm nhưng bản lĩnh; hợp nghề cần quyết đoán, khai phá.',
  'Phá quân': 'Mệnh Phá quân: phá cách, đổi mới, gan dạ, không ưa ràng buộc. '
      'Cuộc đời nhiều biến động, làm lại nhiều lần; thành công nhờ dám thay đổi.',
};

/// Diễn giải khi mỗi chính tinh TỌA CUNG TÀI BẠCH (tiền bạc, cách kiếm/giữ tiền).
const Map<String, String> taiBachChinhTinh = {
  'Tử vi': 'tiền bạc dồi dào, sang trọng; của cải thường đến cùng địa vị, '
      'tiêu pha rộng tay, hợp nguồn thu từ vị thế và quản lý.',
  'Thiên cơ': 'kiếm tiền bằng đầu óc, mưu trí; nhiều nguồn nhỏ và hay biến '
      'động; hợp môi giới, kỹ thuật, tính toán; thu chi thất thường.',
  'Thái Dương': 'tiền đến từ danh tiếng và việc công khai; rộng rãi, hay chi '
      'cho người nên dễ hao; đắc địa thì sung túc, hãm thì vất vả vì tiền.',
  'Vũ khúc': 'chính tài tinh tọa cung tài — rất giỏi kiếm và giữ tiền, hợp '
      'tài chính, kinh doanh; tiền bạc là điểm mạnh nổi bật.',
  'Thiên đồng': 'tài đến nhẹ nhàng, hưởng phúc về tiền, không quá bon chen; '
      'dễ đủ ăn đủ tiêu nhưng ít tích lũy lớn nếu thiếu nghị lực.',
  'Liêm trinh': 'kiếm tiền bằng nghị lực, đôi khi mạo hiểm; tài lộc thăng '
      'trầm, gặp sao tốt thì phát, gặp sát tinh thì hao vì thị phi.',
  'Thiên phủ': 'kho tài — giỏi tích lũy, biết giữ của, tài chính ổn định '
      'sung túc; hợp quản lý ngân quỹ và đầu tư an toàn.',
  'Thái âm': 'chủ tiền của và điền sản tích góp; đắc địa thì giàu ngầm, nhiều '
      'bất động sản; tiền đến đều đặn, kín đáo.',
  'Tham lang': 'tiền từ giao tế và nhiều ngành nghề; thu nhập lớn nhưng tiêu '
      'cũng mạnh, dễ ham đầu tư phiêu lưu, cần tiết chế.',
  'Cự môn': 'kiếm tiền bằng miệng lưỡi/chuyên môn (nói, dạy, tư vấn); dễ vướng '
      'tranh chấp tiền bạc, cần minh bạch rõ ràng.',
  'Thiên tướng': 'tiền bạc đều đặn, hợp lương bổng và vai phụ tá; chi tiêu '
      'chừng mực, trọng uy tín tài chính.',
  'Thiên lương': 'tiền đến từ chuyên môn được trọng vọng (y, giáo, luật); '
      'không ham làm giàu, coi nhẹ vật chất, có quý nhân về tiền.',
  'Thất sát': 'tài lộc thăng trầm mạnh, kiếm bằng nghề cứng/khai phá; dám đầu '
      'tư lớn, lúc được lúc mất.',
  'Phá quân': 'tài lộc biến động, hao tán rồi làm lại; hợp nghề thay đổi/cải '
      'cách, không nên để tiền vào tiền ra liều lĩnh.',
};

/// Diễn giải khi mỗi chính tinh TỌA CUNG QUAN LỘC (sự nghiệp, công danh).
const Map<String, String> quanLocChinhTinh = {
  'Tử vi': 'hợp vị trí lãnh đạo, quản lý cấp cao; công danh hiển đạt, được '
      'cấp trên trọng dụng.',
  'Thiên cơ': 'hợp nghề trí óc, mưu lược, kế hoạch, kỹ thuật, tư vấn; công '
      'việc hay thay đổi, thăng tiến nhờ sáng kiến.',
  'Thái Dương': 'hợp nghề công khai, chính trị, giáo dục, truyền thông; danh '
      'tiếng tốt, đắc địa thì sự nghiệp rạng rỡ.',
  'Vũ khúc': 'hợp tài chính, quân sự, kinh doanh, kỹ thuật; quyết đoán, làm '
      'là tới nơi, dễ nắm thực quyền.',
  'Thiên đồng': 'công việc thiên về dịch vụ, sáng tạo, phúc lợi; thăng tiến '
      'từ tốn, hợp môi trường ôn hòa.',
  'Liêm trinh': 'hợp nghề kỷ luật, hành chính, kỹ thuật, nghệ thuật; sự nghiệp '
      'có thành bại rõ, cần giữ nguyên tắc.',
  'Thiên phủ': 'hợp quản lý, tài chính, hành chính, kho quỹ; sự nghiệp ổn '
      'định, vững chắc, ít sóng gió.',
  'Thái âm': 'hợp nghề liên quan tài sản, văn hóa, cái đẹp, chăm sóc; đắc địa '
      'thăng tiến tốt, có quý nhân nữ giúp.',
  'Tham lang': 'hợp giao tế, kinh doanh, giải trí, ngoại giao và nhiều nghề; '
      'cơ hội rộng, thành công nhờ quan hệ.',
  'Cự môn': 'hợp nghề dùng lời nói/nghiên cứu (luật, giáo, báo, y); thành danh '
      'nhờ chuyên môn, nhưng dễ vướng cạnh tranh.',
  'Thiên tướng': 'hợp vai phụ tá, tham mưu, hành chính, đối ngoại; được tin '
      'cậy, thăng tiến nhờ trung thành.',
  'Thiên lương': 'hợp y dược, giáo dục, pháp luật, từ thiện, giám sát; có uy '
      'tín, được kính trọng.',
  'Thất sát': 'hợp nghề cứng, khai phá, quân đội, kỹ thuật nặng, kinh doanh '
      'mạo hiểm; sự nghiệp thăng trầm nhưng bản lĩnh.',
  'Phá quân': 'hợp nghề cải cách, khai phá, thay đổi, kỹ thuật; sự nghiệp '
      'nhiều biến động, làm lại nhiều lần.',
};

/// Diễn giải khi mỗi chính tinh TỌA CUNG PHU THÊ (hôn nhân, bạn đời).
const Map<String, String> phuTheChinhTinh = {
  'Tử vi': 'bạn đời có cá tính mạnh, địa vị, đáng nể; nên tôn trọng nhau, '
      'tránh cảnh ai cũng muốn làm chủ.',
  'Thiên cơ': 'bạn đời thông minh, nhanh nhạy; hôn nhân cần sự ổn định, tránh '
      'đắn đo và thay đổi quá nhiều.',
  'Thái Dương': 'bạn đời hào phóng, nhiệt tình; nam được vợ tốt, nữ có chồng '
      'có danh (đắc địa); hãm thì vất vả vì bạn đời.',
  'Vũ khúc': 'bạn đời cương nghị, giỏi kiếm tiền nhưng hơi khô khan; nên vun '
      'đắp tình cảm, dễ kết hôn muộn.',
  'Thiên đồng': 'bạn đời hiền hòa, tình cảm; vợ chồng hòa thuận, hưởng phúc, '
      'đời sống lứa đôi êm ấm.',
  'Liêm trinh': 'tình duyên nhiều màu sắc, dễ sóng gió nếu gặp sát tinh; hợp '
      'thì gắn bó sâu sắc, cần chung thủy.',
  'Thiên phủ': 'bạn đời đôn hậu, biết lo toan; gia đình ổn định sung túc, '
      'hôn nhân bền vững.',
  'Thái âm': 'bạn đời dịu dàng, tinh tế, ưa cái đẹp (đắc địa rất tốt); tình '
      'cảm phong phú, gắn bó.',
  'Tham lang': 'bạn đời hấp dẫn, có sức quyến rũ; tình duyên sôi nổi nhưng cần '
      'giữ giới hạn, dễ phức tạp.',
  'Cự môn': 'vợ chồng dễ khẩu thiệt, hiểu lầm; cần lắng nghe, tránh tranh cãi; '
      'hợp thì cùng bàn bạc, nghiên cứu.',
  'Thiên tướng': 'bạn đời trung hậu, công bằng, biết chăm sóc; hôn nhân hài '
      'hòa, tương kính.',
  'Thiên lương': 'bạn đời chững chạc, che chở, thường hơn tuổi hoặc già dặn; '
      'được nương tựa, có khi cách biệt tuổi.',
  'Thất sát': 'bạn đời cá tính mạnh, độc lập; tình duyên thăng trầm, nên kết '
      'hôn muộn, hợp tan rõ ràng.',
  'Phá quân': 'tình duyên nhiều biến động, dễ thay đổi; kết hôn muộn thì bền '
      'hơn, cần bao dung nhường nhịn.',
};

/// Diễn giải khi mỗi chính tinh TỌA CUNG PHÚC ĐỨC (phúc phần, tâm tính, hưởng thụ).
const Map<String, String> phucDucChinhTinh = {
  'Tử vi': 'phúc khí cao quý, tinh thần tự tôn, ưa hưởng thụ sang trọng; tâm '
      'an khi được tôn trọng.',
  'Thiên cơ': 'tâm trí hoạt động không ngừng, thích suy ngẫm và học hỏi; phúc '
      'đến từ trí tuệ, nên tập tĩnh tâm.',
  'Thái Dương': 'tâm sáng, lạc quan, thích cho đi, phúc từ việc thiện; đắc địa '
      'thì an vui, hãm thì hay lo cho người.',
  'Vũ khúc': 'tính thực tế, ít chịu ngồi không, phúc từ lao động; nên học cách '
      'thư giãn, bớt căng thẳng.',
  'Thiên đồng': 'phúc tinh tọa cung phúc — rất tốt: an nhàn, lạc quan, biết '
      'hưởng thụ, tinh thần thư thái.',
  'Liêm trinh': 'nội tâm nhiều suy tư, cảm xúc mạnh; phúc đến khi giữ được kỷ '
      'luật và sự chính trực.',
  'Thiên phủ': 'tâm tính đôn hậu, biết đủ; hưởng phúc ổn định, sung túc cả '
      'tinh thần lẫn vật chất.',
  'Thái âm': 'tâm hồn tinh tế, ưa cái đẹp, đời sống tinh thần phong phú; đắc '
      'địa thì an nhàn, thư thái.',
  'Tham lang': 'ham vui, thích hưởng thụ, đời sống phong phú; cần tiết chế dục '
      'vọng để giữ phúc lâu dài.',
  'Cự môn': 'hay nghĩ ngợi, đa nghi, dễ lo âu; phúc đến khi buông bỏ hoài '
      'nghi, sống cởi mở hơn.',
  'Thiên tướng': 'tâm tính hài hòa, trọng lễ nghĩa, hưởng phúc chừng mực; '
      'tinh thần thanh thản.',
  'Thiên lương': 'phúc thọ, được che chở, tinh thần an định, có khả năng hóa '
      'giải lo âu; chủ trường thọ.',
  'Thất sát': 'nội tâm mạnh mẽ, không chịu ngồi yên; phúc từ phấn đấu, nên học '
      'cách an tĩnh để bớt cô độc.',
  'Phá quân': 'tâm hay xáo động, thích thay đổi, khó an phận; phúc đến khi tìm '
      'được sự ổn định nội tâm.',
};

/// Bảng tra lớp diễn giải SÂU theo cung trọng yếu → chính tinh.
/// Cung khác lớp sâu sẽ luận theo tính chất chung [chinhTinhTinhChat].
const Map<String, Map<String, String>> cungChinhTinhSau = {
  'Mệnh': menhChinhTinh,
  'Tài bạch': taiBachChinhTinh,
  'Quan lộc': quanLocChinhTinh,
  'Phu thê': phuTheChinhTinh,
  'Phúc đức': phucDucChinhTinh,
};

/// Trả về diễn giải sâu của [tenSao] khi tọa [tenCung], hoặc null nếu cung
/// đó chưa có lớp diễn giải sâu (sẽ dùng tính chất chung thay thế).
String? dienGiaiSauChinhTinh(String tenCung, String tenSao) =>
    cungChinhTinhSau[tenCung]?[tenSao];
