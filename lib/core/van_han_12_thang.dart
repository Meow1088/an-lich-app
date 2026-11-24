/// Dự báo vận hạn 12 tháng âm lịch trong năm (THAM KHẢO / giải trí)
/// Tính toán dựa trên:
///  - Địa chi tuổi vs Địa chi của từng tháng (Tam hợp/Lục hợp/Tứ hành xung/Lục hại)
///  - Nạp âm mệnh người vs Nạp âm của từng tháng (Sinh/Khắc/Đồng hành)
///  - Sao chiếu mệnh cửu diệu của tuổi trong năm
library;

import 'can_chi.dart';
import 'hop_tuoi.dart';
import 'nap_am.dart';
import 'sao_han.dart';
import 'xem_tuoi.dart';

const Map<String, String> _sinh = {
  'Mộc': 'Hỏa',
  'Hỏa': 'Thổ',
  'Thổ': 'Kim',
  'Kim': 'Thủy',
  'Thủy': 'Mộc',
};

const Map<String, String> _khac = {
  'Mộc': 'Thổ',
  'Thổ': 'Thủy',
  'Thủy': 'Hỏa',
  'Hỏa': 'Kim',
  'Kim': 'Mộc',
};

class VanHanThang {
  final int thangAm;
  final String canChiThang;
  final NapAm napAmThang;
  final int taiLocSao; // 1..5
  final int congDanhSao; // 1..5
  final int sucKhoeSao; // 1..5
  final int tinhCamSao; // 1..5
  final String nhatDinh; // "Cát", "Bình hòa", "Cần chú ý"
  final String moTaChiTiet;
  final String loiKhuyen;

  const VanHanThang({
    required this.thangAm,
    required this.canChiThang,
    required this.napAmThang,
    required this.taiLocSao,
    required this.congDanhSao,
    required this.sucKhoeSao,
    required this.tinhCamSao,
    required this.nhatDinh,
    required this.moTaChiTiet,
    required this.loiKhuyen,
  });

  int get tongDiemSao => taiLocSao + congDanhSao + sucKhoeSao + tinhCamSao;
  bool get isCat => nhatDinh == 'Cát';
  bool get isXau => nhatDinh == 'Cần chú ý';
}

class VanHan12ThangResult {
  final int lunarYear;
  final String canChiYear;
  final List<VanHanThang> thangs;
  final String tongQuanNam;
  final List<int> thangCat;
  final List<int> thangXau;

  const VanHan12ThangResult({
    required this.lunarYear,
    required this.canChiYear,
    required this.thangs,
    required this.tongQuanNam,
    required this.thangCat,
    required this.thangXau,
  });
}

/// Tính vận hạn 12 tháng cho 1 người trong năm âm lịch `lunarYearTarget`.
VanHan12ThangResult vanHan12Thang({
  required DateTime birthDate,
  required int birthLunarYear,
  required bool isNam,
  required int lunarYearTarget,
}) {
  final tuoiMu = lunarYearTarget - birthLunarYear + 1;
  final saoHan = saoHanOf(tuoiMu, isNam);

  final userChiIdx = (birthLunarYear + 8) % 12;
  final userNapAm = napAmOfYear(birthLunarYear);
  final userHanh = userNapAm.element;

  final listThang = <VanHanThang>[];
  final thangCatList = <int>[];
  final thangXauList = <int>[];

  for (var m = 1; m <= 12; m++) {
    final canChiM = canChiOfMonth(m, lunarYearTarget);
    final napAmM = napAmOfMonth(m, lunarYearTarget);
    final monthChiIdx = (m + 1) % 12;
    final monthHanh = napAmM.element;

    // Tính quan hệ Địa Chi
    double chiScore = 0.0;
    if (userChiIdx == monthChiIdx) {
      chiScore = 0.1;
    } else if (tamHopOf(userChiIdx).contains(monthChiIdx) ||
        isLucHop(userChiIdx, monthChiIdx)) {
      chiScore = 0.6;
    } else if (tuHanhXungOf(userChiIdx).contains(monthChiIdx)) {
      chiScore = -0.7;
    } else if (isLucHai(userChiIdx, monthChiIdx)) {
      chiScore = -0.5;
    }

    // Tính quan hệ Ngũ Hành Nạp Âm
    double hanhScore = 0.0;
    if (userHanh == monthHanh) {
      hanhScore = 0.2;
    } else if (_sinh[monthHanh] == userHanh) {
      // Tháng sinh mệnh ta -> Rất tốt
      hanhScore = 0.7;
    } else if (_sinh[userHanh] == monthHanh) {
      // Ta sinh tháng -> Hao khí
      hanhScore = -0.3;
    } else if (_khac[monthHanh] == userHanh) {
      // Tháng khắc mệnh ta -> Vất vả
      hanhScore = -0.6;
    } else if (_khac[userHanh] == monthHanh) {
      // Ta khắc tháng -> Phải tranh đấu
      hanhScore = -0.2;
    }

    // Điểm sao tổng hợp cho tháng (-1.3 đến +1.4)
    final baseScore = chiScore + hanhScore;

    int calcStar(double bonus) {
      final s = baseScore + bonus;
      if (s >= 0.7) return 5;
      if (s >= 0.25) return 4;
      if (s >= -0.25) return 3;
      if (s >= -0.7) return 2;
      return 1;
    }

    // Tùy theo hung/cát của Sao Hạn năm tác động nhẹ
    double saoBonus = saoHan.tot ? 0.15 : (saoHan.xau ? -0.15 : 0.0);

    final taiLoc = calcStar(saoBonus + 0.1);
    final congDanh = calcStar(saoBonus + 0.05);
    final sucKhoe = calcStar(saoBonus - 0.05);
    final tinhCam = calcStar(saoBonus);

    final avgStar = (taiLoc + congDanh + sucKhoe + tinhCam) / 4.0;
    String nhatDinh;
    if (avgStar >= 3.8) {
      nhatDinh = 'Cát';
      thangCatList.add(m);
    } else if (avgStar <= 2.5) {
      nhatDinh = 'Cần chú ý';
      thangXauList.add(m);
    } else {
      nhatDinh = 'Bình hòa';
    }

    // Mô tả chi tiết & Lời khuyên
    String moTa;
    String khuyen;

    if (chiScore > 0 && hanhScore > 0) {
      moTa =
          'Tháng $m âm lịch ($canChiM — ${napAmM.name}) được xem là tháng ĐẠI CÁT. Địa chi Tam/Lục hợp kết hợp Ngũ hành Nạp âm tương sinh giúp mọi sự tiến triển vô cùng thuận lợi, dễ gặp quý nhân nâng đỡ.';
      khuyen =
          'Nên nắm bắt thời cơ để khai trương, mở rộng đầu tư, thực hiện các dự định lớn hoặc gắn kết tình cảm gia đình.';
    } else if (chiScore < 0 || hanhScore < 0) {
      if (chiScore < 0 && hanhScore < 0) {
        moTa =
            'Tháng $m âm lịch ($canChiM — ${napAmM.name}) là tháng CẦN THẬN TRỌNG. Địa chi tương xung/hại cộng với Ngũ hành bị xung khắc dễ phát sinh cản trở, thị phi hoặc hao hụt năng lượng.';
        khuyen =
            'Tránh khởi sự công việc lớn, hạn chế đầu tư mạo hiểm, chú ý giữ gìn sức khỏe và kiềm chế trong giao tiếp.';
      } else if (chiScore < 0) {
        moTa =
            'Tháng $m âm lịch ($canChiM — ${napAmM.name}) có Địa chi xung kỵ với bản mệnh. Công việc hay di chuyển có thể gặp chút trắc trở nhỏ hoặc mâu thuẫn ý kiến.';
        khuyen =
            'Cần nhẫn nại, kiểm tra kỹ hợp đồng giấy tờ và chú ý an toàn khi đi lại.';
      } else {
        moTa =
            'Tháng $m âm lịch ($canChiM — ${napAmM.name}) có Ngũ hành nạp âm khắc chế. Cơ thể dễ mệt mỏi hoặc tiền bạc có khoản chi ngoài dự kiến.';
        khuyen =
            'Cân bằng giữa làm việc và nghỉ ngơi, quản lý tài chính chặt chẽ, tránh thức khuya.';
      }
    } else {
      moTa =
          'Tháng $m âm lịch ($canChiM — ${napAmM.name}) duy trì ở mức BÌNH HÒA. Vận trình ổn định, không có biến động lớn, thích hợp tích lũy và hoàn thiện kế hoạch dở dang.';
      khuyen =
          'Duy trì công việc ổn định, tích lũy nội lực và dành thời gian chăm sóc bản thân.';
    }

    listThang.add(
      VanHanThang(
        thangAm: m,
        canChiThang: canChiM,
        napAmThang: napAmM,
        taiLocSao: taiLoc,
        congDanhSao: congDanh,
        sucKhoeSao: sucKhoe,
        tinhCamSao: tinhCam,
        nhatDinh: nhatDinh,
        moTaChiTiet: moTa,
        loiKhuyen: khuyen,
      ),
    );
  }

  final canChiYearTarget = canChiOfYear(lunarYearTarget);
  final tongQuan =
      'Năm $lunarYearTarget ($canChiYearTarget), ở tuổi mụ $tuoiMu, gia chủ gặp sao chiếu mệnh ${saoHan.name} (${saoHan.loaiLabel}). Trong 12 tháng âm lịch, có ${thangCatList.length} tháng vượng khí cát lành (${thangCatList.isEmpty ? 'Không có' : 'Tháng ${thangCatList.join(', ')}'}) và ${thangXauList.length} tháng cần chú ý giữ gìn (${thangXauList.isEmpty ? 'Không có' : 'Tháng ${thangXauList.join(', ')}'}).';

  return VanHan12ThangResult(
    lunarYear: lunarYearTarget,
    canChiYear: canChiYearTarget,
    thangs: listThang,
    tongQuanNam: tongQuan,
    thangCat: thangCatList,
    thangXau: thangXauList,
  );
}
