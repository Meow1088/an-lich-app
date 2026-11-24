/// Tử vi hằng ngày (THAM KHẢO / giải trí) — chấm điểm Tài lộc / Công việc /
/// Sức khỏe / Tình cảm cho 1 người trong NGÀY, suy từ:
///  - Quan hệ địa chi tuổi người vs chi ngày (tam hợp/lục hợp/xung/hại)
///  - Ngũ hành nạp âm mệnh người vs nạp âm ngày (sinh/khắc)
///  - Hoàng đạo / Hắc đạo của ngày
///  - Biorhythm (thể chất/cảm xúc/trí tuệ) từ ngày sinh
/// Tất cả tính cục bộ, không gọi mạng.
library;

import 'biorhythm.dart';
import 'can_chi.dart';
import 'hoang_dao.dart';
import 'hop_tuoi.dart';
import 'xem_tuoi.dart';

const Map<String, String> _sinh = {
  'Mộc': 'Hỏa', 'Hỏa': 'Thổ', 'Thổ': 'Kim', 'Kim': 'Thủy', 'Thủy': 'Mộc',
};
const Map<String, String> _khac = {
  'Mộc': 'Thổ', 'Thổ': 'Thủy', 'Thủy': 'Hỏa', 'Hỏa': 'Kim', 'Kim': 'Mộc',
};

double _chiRelN(int p, int d) {
  if (p == d) return 0.3;
  if (tamHopOf(p).contains(d) || isLucHop(p, d)) return 0.7;
  if (tuHanhXungOf(p).contains(d)) return -0.8;
  if (isLucHai(p, d)) return -0.5;
  return 0.0;
}

double _menhN(String p, String d) {
  if (p == d) return 0.2;
  if (_sinh[d] == p) return 0.6; // ngày sinh mệnh ta -> trợ lực
  if (_sinh[p] == d) return -0.4; // ta sinh ngày -> hao khí
  if (_khac[d] == p || _khac[p] == d) return -0.6;
  return 0.0;
}

int _sao(double x) {
  if (x >= 0.5) return 5;
  if (x >= 0.15) return 4;
  if (x > -0.15) return 3;
  if (x > -0.5) return 2;
  return 1;
}

class TuViMuc {
  final String label;
  final String icon; // emoji
  final int sao; // 1..5
  final String moTa;
  const TuViMuc(this.label, this.icon, this.sao, this.moTa);
  bool get tot => sao >= 4;
  bool get xau => sao <= 2;
}

class TuViNgay {
  final List<TuViMuc> mucs; // Tài lộc, Công việc, Sức khỏe, Tình cảm
  final String tongQuan;
  final int tongSao;
  const TuViNgay(this.mucs, this.tongQuan, this.tongSao);
}

const List<List<String>> _moTa = [
  // [Tài lộc] theo sao 1..5
  [
    'Dễ hao tài — tránh cho vay, đầu tư mạo hiểm hay mua sắm bốc đồng hôm nay.',
    'Tiền nong hơi trục trặc, nên cân nhắc kỹ trước khi chi khoản lớn.',
    'Tài chính ổn định, không biến động lớn. Cứ duy trì kế hoạch như thường.',
    'Tiền bạc khá thuận, chi tiêu trong tầm kiểm soát. Có thể bàn chuyện làm ăn.',
    'Tài lộc hanh thông, dễ có khoản thu bất ngờ. Hợp ký kết, thu hồi công nợ.',
  ],
  // [Công việc]
  [
    'Dễ gặp cản trở, hiểu lầm. Tránh quyết định lớn, lùi việc hệ trọng nếu được.',
    'Công việc dễ vướng trục trặc nhỏ, cần kiên nhẫn và kiểm tra kỹ lại.',
    'Công việc bình thường, làm tới đâu chắc tới đó. Đừng ôm việc quá sức.',
    'Công việc tiến triển tốt, dễ được ủng hộ. Mạnh dạn đề xuất ý tưởng.',
    'Thuận buồm xuôi gió, đầu óc minh mẫn. Hợp trình bày, chốt việc quan trọng.',
  ],
  // [Sức khỏe]
  [
    'Dễ mệt mỏi, đề phòng cảm vặt. Nên nghỉ ngơi, không gắng sức hôm nay.',
    'Cơ thể hơi uể oải, nên nghỉ ngơi nhiều hơn, tránh thức khuya.',
    'Sức khỏe ổn, nhớ ăn uống điều độ và ngủ đủ giấc.',
    'Sức khỏe tốt, năng lượng dồi dào. Duy trì vận động vừa phải.',
    'Thể trạng sung sức, tinh thần phấn chấn. Tốt để vận động, làm việc nặng.',
  ],
  // [Tình cảm]
  [
    'Dễ nóng giận, hiểu lầm. Hạn chế tranh luận và lời nói lúc bực bội.',
    'Cảm xúc dễ thất thường, nên giữ bình tĩnh khi trò chuyện.',
    'Tình cảm êm đềm, không sóng gió. Dành chút thời gian cho người thân.',
    'Cảm xúc tích cực, giao tiếp cởi mở. Dễ làm hòa, kết nối.',
    'Tâm trạng vui vẻ, dễ đồng cảm. Ngày đẹp để hẹn hò, gắn kết người thân.',
  ],
];

/// Tính tử vi hằng ngày cho một người.
TuViNgay tuViNgay(DateTime birthDate, int birthLunarYear, DateTime today) {
  final pChi = yearChiIndex(birthLunarYear);
  final pMenh = napAmOfYear(birthLunarYear).element;
  final dChi = chiIndexOfDay(today.day, today.month, today.year);
  final dMenh = napAmOfDay(today.day, today.month, today.year).element;
  final hoangN = dayQuality(today.day, today.month, today.year).isHoangDao
      ? 0.4
      : -0.4;
  final chiN = _chiRelN(pChi, dChi);
  final menhN = _menhN(pMenh, dMenh);
  final phy = physical(birthDate, today);
  final emo = emotional(birthDate, today);
  final intel = intellectual(birthDate, today);

  final taiLoc = chiN * 0.4 + menhN * 0.4 + hoangN * 0.2;
  final congViec = hoangN * 0.4 + chiN * 0.3 + intel * 0.3;
  final sucKhoe = phy * 0.6 + hoangN * 0.2 + emo * 0.2;
  final tinhCam = emo * 0.6 + (isLucHop(pChi, dChi) ? 0.3 : 0.0) + chiN * 0.2;

  final mucs = [
    TuViMuc('Tài lộc', '💰', _sao(taiLoc), _moTa[0][_sao(taiLoc) - 1]),
    TuViMuc('Công việc', '💼', _sao(congViec), _moTa[1][_sao(congViec) - 1]),
    TuViMuc('Sức khỏe', '🌿', _sao(sucKhoe), _moTa[2][_sao(sucKhoe) - 1]),
    TuViMuc('Tình cảm', '💗', _sao(tinhCam), _moTa[3][_sao(tinhCam) - 1]),
  ];
  final tong = mucs.fold(0, (a, m) => a + m.sao);

  String tq;
  if (tong >= 17) {
    tq = 'Hôm nay là một ngày đẹp với bạn — hãy tận dụng để làm việc quan trọng.';
  } else if (tong >= 13) {
    tq = 'Một ngày khá thuận lợi. Giữ tinh thần tích cực, mọi việc sẽ trôi chảy.';
  } else if (tong >= 9) {
    tq = 'Ngày bình thường, không quá tốt cũng không xấu. Cứ làm việc đều đặn.';
  } else {
    tq = 'Hôm nay vận chưa thuận, nên cẩn trọng, ưu tiên giữ sức và tránh việc lớn.';
  }
  final yeu = mucs.where((m) => m.xau).map((m) => m.label).toList();
  if (yeu.isNotEmpty) tq += ' Đặc biệt chú ý: ${yeu.join(', ')}.';

  return TuViNgay(mucs, tq, tong);
}
