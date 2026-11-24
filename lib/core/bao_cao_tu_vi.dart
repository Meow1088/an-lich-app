/// Engine "Hồ sơ vận trình" — tổng hợp lá số tử vi thành một BÁO CÁO có cấu
/// trúc, giọng đời thường (văn xuôi tự nhiên, hạn chế thuật ngữ), để hiển thị
/// và xuất PDF chuyên nghiệp.
///
/// KHÔNG thêm luật an-sao mới: chỉ COMPOSE từ các lớp đã có (`tu_vi_dien_giai`
/// chế độ Cơ bản + `tu_vi_tong_hop`) rồi diễn đạt lại thành văn + gợi ý hành
/// động chung theo mức điểm. Core độc lập `data/` (nhận hồ sơ qua tham số).
/// Mọi nội dung mang tính THAM KHẢO / tự khám phá bản thân.
library;

import 'can_chi.dart';
import 'tu_vi.dart';
import 'tu_vi_dien_giai.dart';
import 'tu_vi_tong_hop.dart';

/// Một điểm số có nhãn (dùng cho biểu đồ thanh: chủ đề, độ phù hợp nghề).
class MucDiem {
  final String ten;
  final int sao; // 1..5
  const MucDiem(this.ten, this.sao);
}

/// Một mốc trên trục thời gian đại vận (mỗi 10 năm).
class MocVanHan {
  final String tuoi; // '24–33 tuổi'
  final int sao; // 1..5
  final String trongTam; // cung trọng tâm
  final String nhanXet;
  const MocVanHan(this.tuoi, this.sao, this.trongTam, this.nhanXet);
}

/// Một mục trong báo cáo.
class BaoCaoMuc {
  final String tieuDe;
  final String icon;
  final int? sao; // điểm tổng của mục (1..5) hoặc null
  final List<String> doan; // các đoạn văn xuôi
  final List<String> nen; // gợi ý "Bạn nên" (hộp xanh)
  final List<String> tranh; // gợi ý "Cần lưu ý" (hộp đỏ, tùy chọn)
  final List<MucDiem> diem; // biểu đồ thanh (tùy chọn)
  const BaoCaoMuc(
    this.tieuDe,
    this.icon,
    this.doan, {
    this.sao,
    this.nen = const [],
    this.tranh = const [],
    this.diem = const [],
  });
}

/// Toàn bộ báo cáo tử vi cá nhân.
class BaoCaoTuVi {
  final String tieuDe;
  final Map<String, String> hoSo;
  final String disclaimer;
  final BaoCaoMuc tomTat; // Tóm tắt điều hành (Executive Summary)
  final List<BaoCaoMuc> mucs;
  final List<MocVanHan> timeline; // đại vận theo thập niên
  const BaoCaoTuVi({
    required this.tieuDe,
    required this.hoSo,
    required this.disclaimer,
    required this.tomTat,
    required this.mucs,
    required this.timeline,
  });
}

const String _disclaimer =
    'Báo cáo này được xây dựng dựa trên nguyên lý Tử Vi Đẩu Số kết hợp hệ thống '
    'diễn giải tự động. Nội dung mang tính tham khảo, định hướng và tự khám phá '
    'bản thân, không phải dự đoán chắc chắn về tương lai.';

CungTuVi _cung(LaSoTuVi la, String ten) =>
    la.cung.firstWhere((c) => c.tenCung == ten);

String _mucChu(int sao) => switch (sao) {
      5 => 'rất tốt',
      4 => 'khá tốt',
      3 => 'trung bình, cân đối',
      2 => 'cần cố gắng thêm',
      _ => 'nhiều thử thách, nên kiên trì',
    };

/// Nối danh sách thành cụm văn xuôi: [a, b, c] -> "a, b và c".
String _liet(List<String> xs) {
  final v = xs.where((e) => e.trim().isNotEmpty).toList();
  if (v.isEmpty) return '';
  if (v.length == 1) return v.first;
  return '${v.sublist(0, v.length - 1).join(', ')} và ${v.last}';
}

/// Viết hoa chữ cái đầu.
String _hoa(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Bỏ dòng tiêu đề cung đầu tiên trong diễn giải để lấy phần thân.
String _than(CungTuVi cung) => dienGiaiCung(cung, mode: CheDoXem.coBan)
    .replaceAll(RegExp(r'^[^\n]*\n'), '')
    .trim();

/// Đoạn văn cho một cung: dẫn nhập theo mức + diễn giải sẵn có.
List<String> _doanCung(CungTuVi cung, String linhVuc) {
  final sao = diemCung(cung);
  final than = _than(cung);
  final dan = 'Về $linhVuc, lá số của bạn ở mức ${_mucChu(sao)}. ';
  return [dan + than];
}

const Map<String, List<List<String>>> _nenTheoLinhVuc = {
  // linhVuc -> [thap(<=2), tb(3), cao(>=4)]
  'sự nghiệp': [
    [
      'Kiên trì theo đuổi một lĩnh vực đủ lâu thay vì đổi việc liên tục',
      'Chủ động học thêm kỹ năng chuyên môn để tạo lợi thế'
    ],
    [
      'Đặt mục tiêu rõ ràng cho 1–3 năm tới',
      'Tìm một người dẫn dắt hoặc môi trường tốt để phát triển'
    ],
    [
      'Mạnh dạn nắm cơ hội thăng tiến khi đến',
      'Xây dựng uy tín và mở rộng quan hệ nghề nghiệp'
    ],
  ],
  'tài chính': [
    [
      'Ưu tiên tiết kiệm, tránh vay nợ cho tiêu dùng',
      'Không đầu tư theo cảm xúc hay lời mách'
    ],
    [
      'Lập kế hoạch chi tiêu và quỹ dự phòng',
      'Đa dạng nguồn thu một cách thận trọng'
    ],
    [
      'Tận dụng khả năng kiếm tiền để tích lũy dài hạn',
      'Đầu tư có kỷ luật, tránh ôm quá nhiều cùng lúc'
    ],
  ],
  'tình duyên': [
    [
      'Kiên nhẫn, tránh nóng vội trong chuyện tình cảm',
      'Lắng nghe và chia sẻ với người bạn đời nhiều hơn'
    ],
    [
      'Dành thời gian vun đắp, tránh vì công việc mà lơ là',
      'Nói ra mong muốn thay vì giữ trong lòng'
    ],
    [
      'Trân trọng và giữ gìn mối quan hệ đang có',
      'Cân bằng giữa cái tôi và sự nhường nhịn'
    ],
  ],
  'sức khỏe': [
    [
      'Khám sức khỏe định kỳ và ngủ đủ giấc',
      'Giảm căng thẳng, tránh làm việc quá sức'
    ],
    [
      'Duy trì vận động đều đặn mỗi tuần',
      'Ăn uống điều độ, hạn chế thức khuya'
    ],
    [
      'Giữ lối sống lành mạnh để duy trì thể trạng tốt',
      'Vẫn nên khám định kỳ để phòng xa'
    ],
  ],
  'gia đạo': [
    [
      'Dành nhiều thời gian hơn cho gia đình',
      'Kiên nhẫn dung hòa khác biệt giữa các thế hệ'
    ],
    [
      'Giữ liên lạc, quan tâm người thân thường xuyên',
      'Chia sẻ trách nhiệm trong nhà'
    ],
    [
      'Phát huy vai trò gắn kết trong gia đình',
      'Duy trì không khí ấm áp, tương trợ lẫn nhau'
    ],
  ],
};

List<String> _nen(String linhVuc, int sao) {
  final b = _nenTheoLinhVuc[linhVuc];
  if (b == null) return const [];
  final idx = sao <= 2 ? 0 : (sao == 3 ? 1 : 2);
  return b[idx];
}

// Độ phù hợp nghề nghiệp (rule-based theo chính tinh Mệnh/Quan/Tài).
const Map<String, List<String>> _phuHopSao = {
  'Làm chủ / khởi nghiệp': ['Tử vi', 'Thất sát', 'Phá quân', 'Tham lang', 'Vũ khúc'],
  'Đầu tư / quản lý tiền': ['Vũ khúc', 'Thiên phủ', 'Thái âm', 'Tham lang'],
  'Quản lý / lãnh đạo': ['Tử vi', 'Thiên phủ', 'Thiên tướng', 'Thiên lương', 'Vũ khúc'],
  'Kinh doanh / giao thương': ['Tham lang', 'Vũ khúc', 'Thiên cơ', 'Phá quân', 'Cự môn'],
  'Nhà nước / hành chính': ['Thái Dương', 'Thiên lương', 'Thiên tướng', 'Cự môn', 'Liêm trinh'],
};

List<MucDiem> _doPhuHop(LaSoTuVi la) {
  final ten = <String>{
    for (final c in [la.cungMenh, _cung(la, 'Quan lộc'), _cung(la, 'Tài bạch')])
      for (final s in c.chinhTinh) s.ten,
  };
  return [
    for (final e in _phuHopSao.entries)
      MucDiem(e.key, (2 + e.value.where(ten.contains).length).clamp(1, 5)),
  ];
}

// Đại vận theo thập niên (timeline).
List<MocVanHan> _timeline(LaSoTuVi la) {
  final cungs = [...la.cung]..sort((a, b) => a.daiHanTu.compareTo(b.daiHanTu));
  final out = <MocVanHan>[];
  for (final c in cungs) {
    if (c.daiHanTu < 1 || c.daiHanTu > 75) continue;
    final sao = diemCung(c);
    out.add(MocVanHan(
        '${c.daiHanTu}–${c.daiHanTu + 9} tuổi', sao, c.tenCung, _mucChu(sao)));
  }
  return out;
}

/// Báo cáo tổng quan cuộc đời.
BaoCaoTuVi baoCaoTongQuan(
  LaSoTuVi la, {
  String name = '',
  required DateTime birthDate,
  required String genderLabel,
  int? hourChi,
  String gioGhiChu = '',
}) {
  final napAm = napAmOfYear(la.lunar.year).name;
  final gioLabel = hourChi == null ? 'Không rõ' : gioLabels[hourChi];

  final hoSo = <String, String>{
    'Họ tên': name.isEmpty ? 'Bạn' : name,
    'Giới tính': genderLabel,
    'Ngày sinh': 'DL ${birthDate.day}/${birthDate.month}/${birthDate.year} '
        '· ÂL ${la.lunar.day}/${la.lunar.month}/${la.lunar.year}',
    'Giờ sinh': '$gioLabel$gioGhiChu',
    'Bản mệnh': '${la.canChiNam} · $napAm',
    'Cục': la.cucTen,
    'Mệnh · Thân chủ': '${la.menhChu} · ${la.thanChu}',
  };

  final tk = tongKet(la);
  final cd = chamChuDe(la);
  final tb = (cd.map((c) => c.sao).reduce((a, b) => a + b) / cd.length).round();

  final yeuText = tk.diemYeu.isEmpty
      ? 'việc giữ sự kiên định và mục tiêu dài hạn'
      : _liet(tk.diemYeu).toLowerCase();

  final tomTat = BaoCaoMuc(
    'Tóm tắt điều hành',
    '⭐',
    [
      'Nhìn chung lá số của bạn ở mức ${_mucChu(tb)}. '
          '${_hoa(_liet(tk.diemManh).toLowerCase())} là những nét nổi bật giúp '
          'bạn tạo dấu ấn.',
      'Bên cạnh đó, $yeuText là điều nên lưu tâm để đi đường dài. '
          'Bạn phù hợp với những công việc như ${_liet(tk.ngheHop).toLowerCase()}. '
          '${tk.loiKhuyen}',
    ],
    sao: tb,
    diem: [for (final c in cd) MucDiem(c.ten, c.sao)],
  );

  final mucs = <BaoCaoMuc>[
    BaoCaoMuc(
        'Tính cách',
        '🧭',
        [
          dienGiaiMenh(la, mode: CheDoXem.coBan)
              .replaceFirst(RegExp(r'^[^\n]*\n'), '')
              .trim()
        ],
        sao: diemCung(la.cungMenh)),
    _mucLinhVuc(la, '💼', 'Sự nghiệp', 'Quan lộc', 'sự nghiệp'),
    _mucLinhVuc(la, '💰', 'Tài chính', 'Tài bạch', 'tài chính'),
    _mucLinhVuc(la, '❤️', 'Tình duyên & hôn nhân', 'Phu thê', 'tình duyên'),
    _mucLinhVuc(la, '🏠', 'Gia đạo', 'Điền trạch', 'gia đạo'),
    _mucChuDeCard(cd, 'Con cái', '👶'),
    _mucLinhVuc(la, '🌿', 'Sức khỏe', 'Tật ách', 'sức khỏe'),
    _mucXaHoi(la),
    BaoCaoMuc('Phúc đức & tinh thần', '🍀',
        _doanCung(_cung(la, 'Phúc đức'), 'phúc phần và đời sống tinh thần'),
        sao: diemCung(_cung(la, 'Phúc đức'))),
    BaoCaoMuc('Độ phù hợp nghề nghiệp', '📊', [
      'Dựa trên các sao chính ở cung Mệnh, Quan lộc và Tài bạch, dưới đây là '
          'mức phù hợp của bạn với một số hướng đi. Đây là gợi ý định hướng, '
          'không phải giới hạn — nỗ lực và môi trường vẫn là yếu tố quyết định.',
    ], diem: _doPhuHop(la)),
    _mucKeHoach(la, tk, cd),
  ];

  return BaoCaoTuVi(
    tieuDe: 'Hồ sơ vận trình',
    hoSo: hoSo,
    disclaimer: _disclaimer,
    tomTat: tomTat,
    mucs: mucs,
    timeline: _timeline(la),
  );
}

BaoCaoMuc _mucLinhVuc(
    LaSoTuVi la, String icon, String tieuDe, String tenCung, String linhVuc) {
  final cung = _cung(la, tenCung);
  final sao = diemCung(cung);
  return BaoCaoMuc(tieuDe, icon, _doanCung(cung, linhVuc),
      sao: sao, nen: _nen(linhVuc, sao));
}

BaoCaoMuc _mucChuDeCard(List<ChamChuDe> cd, String ten, String icon) {
  final c = cd.firstWhere((x) => x.ten == ten,
      orElse: () => ChamChuDe(ten, icon, 3, ''));
  return BaoCaoMuc(ten, icon,
      [c.nhanXet.isEmpty ? 'Đường con cái ở mức trung bình.' : c.nhanXet],
      sao: c.sao);
}

BaoCaoMuc _mucXaHoi(LaSoTuVi la) {
  final no = _cung(la, 'Nô bộc');
  final huynh = _cung(la, 'Huynh đệ');
  final sao = ((diemCung(no) + diemCung(huynh)) / 2).round();
  return BaoCaoMuc('Quan hệ xã hội', '🤝', [
    'Về bạn bè, đồng nghiệp và anh chị em, lá số của bạn ở mức ${_mucChu(sao)}. '
        '${_than(no)}',
  ], sao: sao);
}

BaoCaoMuc _mucKeHoach(LaSoTuVi la, TongKet tk, List<ChamChuDe> cd) {
  final sap = [...cd]..sort((a, b) => a.sao.compareTo(b.sao));
  final yeu = sap.first;
  final nen = <String>[
    ...tk.diemManh.take(2).map((e) => 'Phát huy thế mạnh: ${e.toLowerCase()}'),
    ..._nen(_mapLinhVuc(yeu.ten), yeu.sao),
    'Giữ lối sống điều độ và các mối quan hệ tích cực',
  ];
  return BaoCaoMuc('Kế hoạch hành động', '✅', [
    'Tổng hợp lại, để phát huy lá số của mình, bạn nên tập trung vào những '
        'việc thiết thực sau đây trong thời gian tới.',
  ], nen: nen);
}

String _mapLinhVuc(String chuDe) => switch (chuDe) {
      'Sự nghiệp' => 'sự nghiệp',
      'Tài chính' => 'tài chính',
      'Tình duyên' => 'tình duyên',
      'Sức khỏe' => 'sức khỏe',
      _ => 'gia đạo',
    };
