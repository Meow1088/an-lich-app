/// Sao hạn Cửu diệu (9 sao chiếu mệnh) theo tuổi mụ + giới tính.
/// THAM KHẢO / tín ngưỡng dân gian. Verify nguồn 2026-06-26: nam bắt đầu
/// 10 tuổi = La Hầu; nữ 10 tuổi = Kế Đô; nam 31 = Thái Bạch, nữ 31 = Thái Âm.
library;

const List<String> _namSeq = [
  'La Hầu', 'Thổ Tú', 'Thủy Diệu', 'Thái Bạch', 'Thái Dương',
  'Vân Hớn', 'Kế Đô', 'Thái Âm', 'Mộc Đức',
];
const List<String> _nuSeq = [
  'Kế Đô', 'Vân Hớn', 'Mộc Đức', 'Thái Âm', 'Thổ Tú',
  'La Hầu', 'Thái Dương', 'Thái Bạch', 'Thủy Diệu',
];

const Set<String> _tot = {'Thái Dương', 'Thái Âm', 'Mộc Đức'};
const Set<String> _xau = {'La Hầu', 'Kế Đô', 'Thái Bạch'};

class SaoHanInfo {
  final String tongQuan; // tính chất ngôi sao
  final String anhHuong; // ảnh hưởng trong năm
  final String luuY; // tháng kỵ/tốt + lời khuyên / hóa giải
  const SaoHanInfo(this.tongQuan, this.anhHuong, this.luuY);
}

const Map<String, SaoHanInfo> _info = {
  'La Hầu': SaoHanInfo(
    'La Hầu là hung tinh đứng đầu cửu diệu, chủ về khẩu thiệt, thị phi, tang thương và tật ách ở vùng đầu, mắt, máu huyết. Người xưa cho rằng nam giới gặp sao này thường nặng hơn nữ giới.',
    'Trong năm dễ vướng tranh cãi, kiện tụng, giấy tờ trục trặc, hao tổn tinh thần và tiền của. Cần giữ lời ăn tiếng nói, cẩn trọng hợp đồng và để ý sức khỏe vùng đầu – mắt – huyết áp.',
    'Kỵ nhất tháng Giêng và tháng 7 âm lịch. Nên sống điềm đạm, tránh thị phi và việc kiện tụng; dân gian cúng dâng sao giải hạn La Hầu hướng Bắc, thắp 9 ngọn đèn vào tối ngày 8 âm lịch.',
  ),
  'Kế Đô': SaoHanInfo(
    'Kế Đô là hung tinh, chủ sự ám muội, buồn phiền, thị phi ngấm ngầm và chuyện không may bất ngờ. Nữ giới thường chịu ảnh hưởng rõ hơn nam giới.',
    'Năm nay tâm trạng dễ u uất, hay gặp chuyện hiểu lầm, mất mát ngoài ý muốn, công việc trắc trở khó nói. Đề phòng tiểu nhân, giữ gìn sức khỏe và tránh đầu tư mạo hiểm.',
    'Kỵ nhất tháng 3 và tháng 9 âm lịch. Nên làm việc thiện, giữ tâm an; dân gian cúng sao Kế Đô hướng Tây, thắp 21 ngọn đèn vào tối ngày 18 âm lịch.',
  ),
  'Thái Bạch': SaoHanInfo(
    'Thái Bạch là hung tinh chủ về hao tài tốn của — dân gian có câu "Thái Bạch sạch cửa nhà". Sao này mang hành Kim, ảnh hưởng nhiều đến tiền bạc và tài sản.',
    'Trong năm dễ hao hụt tiền của, mất mát tài sản, làm ăn thất thoát, chi tiêu vượt dự tính. Nên thận trọng trong vay mượn, đầu tư, hùn hạp và giữ kỹ tài sản, giấy tờ.',
    'Kỵ nhất tháng 5 âm lịch. Nên chi tiêu dè dặt, tránh kinh doanh mạo hiểm; dân gian cúng sao Thái Bạch hướng Tây, thắp 15 ngọn đèn vào tối ngày 15 âm lịch.',
  ),
  'Thái Dương': SaoHanInfo(
    'Thái Dương là cát tinh sáng nhất, tượng trưng mặt trời, chủ về công danh, quyền quý và may mắn. Nam giới gặp sao này rất tốt, nữ giới hưởng phúc ở mức vừa phải.',
    'Năm nay công danh hanh thông, dễ được quý nhân nâng đỡ, gặp nhiều tin vui, thuận lợi cho thi cử, thăng tiến và mở rộng việc làm ăn.',
    'Tốt nhất vào tháng 6 và tháng 10 âm lịch — nên tận dụng để khởi sự việc lớn. Dân gian cúng tạ sao Thái Dương hướng Đông, thắp 12 ngọn đèn tối ngày 27 âm lịch.',
  ),
  'Thái Âm': SaoHanInfo(
    'Thái Âm là cát tinh, tượng trưng mặt trăng, chủ về tài lộc, hỉ sự và quý nhân phù trợ. Nữ giới gặp sao này đặc biệt tốt.',
    'Năm nay tài lộc dồi dào, dễ có hỉ sự (cưới hỏi, sinh con, mua nhà), được người tốt giúp đỡ, tình cảm và gia đạo êm ấm.',
    'Tốt nhất vào tháng 8 và tháng 11 âm lịch. Là năm thuận để cưới hỏi, khai trương, mua sắm lớn. Dân gian cúng tạ sao Thái Âm hướng Tây, thắp 7 ngọn đèn tối 26 âm lịch.',
  ),
  'Mộc Đức': SaoHanInfo(
    'Mộc Đức là cát tinh hành Mộc, chủ về hỉ sự, sức khỏe và bình an. Sao mang năng lượng sinh sôi, nuôi dưỡng.',
    'Năm nay sức khỏe tốt lên, tinh thần phấn chấn, gia đạo vui vẻ, dễ có tin mừng về con cái hoặc hôn nhân. Thuận cho việc dưỡng sức và vun đắp các mối quan hệ.',
    'Là năm bình an, ít kỵ. Nên giữ nếp sống lành mạnh để duy trì vận tốt. Dân gian cúng tạ sao Mộc Đức hướng Đông, thắp 20 ngọn đèn tối ngày 25 âm lịch.',
  ),
  'Vân Hớn': SaoHanInfo(
    'Vân Hớn (Vân Hán) là trung tinh thiên về xấu, hành Hỏa, chủ về khẩu thiệt, nóng giận và nguy cơ tai nạn liên quan đến lửa, máu huyết.',
    'Năm nay dễ nóng nảy dẫn đến cãi vã, mâu thuẫn; cần đề phòng hỏa hoạn, tai nạn và bệnh về máu. Phụ nữ chú ý sức khỏe thai sản.',
    'Kỵ nhất tháng 2 và tháng 8 âm lịch. Nên kiềm chế cảm xúc, cẩn thận với lửa và xe cộ. Dân gian cúng sao Vân Hớn hướng Nam, thắp 15 ngọn đèn tối ngày 29 âm lịch.',
  ),
  'Thổ Tú': SaoHanInfo(
    'Thổ Tú là trung tinh thiên về xấu, hành Thổ, chủ về sự trì trệ, chậm chạp và phiền muộn vặt vãnh.',
    'Năm nay công việc dễ đình trệ, gặp trở ngại nhỏ kéo dài, hao tốn vì chuyện ruộng đất, nhà cửa; đề phòng tiểu nhân và bệnh về tiêu hóa.',
    'Kỵ nhất tháng 4 và tháng 8 âm lịch. Nên kiên nhẫn, không nóng vội khởi sự lớn. Dân gian cúng sao Thổ Tú hướng Tây, thắp 5 ngọn đèn tối ngày 19 âm lịch.',
  ),
  'Thủy Diệu': SaoHanInfo(
    'Thủy Diệu là trung tinh, hành Thủy. Với nam giới thiên về tốt (tài lộc), với nữ giới thiên về xấu; chủ về chuyện liên quan sông nước.',
    'Nam giới năm nay dễ có thêm tài lộc, hanh thông; nữ giới nên đề phòng thị phi, buồn phiền. Cả hai chú ý an toàn khi đi sông nước, tránh ăn uống quá độ.',
    'Kỵ tháng 4 và tháng 8 âm lịch. Nên cẩn thận lời nói và sông nước. Dân gian cúng sao Thủy Diệu hướng Bắc, thắp 7 ngọn đèn tối ngày 21 âm lịch.',
  ),
};

class SaoHan {
  final String name;
  final int loai; // 1 tốt, 0 trung tính, -1 xấu
  final SaoHanInfo info;
  const SaoHan(this.name, this.loai, this.info);

  bool get tot => loai == 1;
  bool get xau => loai == -1;
  String get loaiLabel =>
      loai == 1 ? 'Cát tinh' : (loai == -1 ? 'Hung tinh' : 'Trung tinh');
  String get tongQuan => info.tongQuan;
  String get anhHuong => info.anhHuong;
  String get luuY => info.luuY;
}

/// Sao chiếu mệnh của một người theo tuổi mụ + giới tính.
SaoHan saoHanOf(int tuoiMu, bool isNam) {
  final seq = isNam ? _namSeq : _nuSeq;
  final idx = (((tuoiMu - 10) % 9) + 9) % 9;
  final name = seq[idx];
  final loai = _tot.contains(name) ? 1 : (_xau.contains(name) ? -1 : 0);
  return SaoHan(name, loai, _info[name]!);
}
