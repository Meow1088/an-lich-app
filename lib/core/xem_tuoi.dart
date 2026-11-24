/// Xem tuổi làm nhà (Kim Lâu, Hoang Ốc, Tam Tai) + Tam hợp / Tứ hành xung.
/// THAM KHẢO / tín ngưỡng dân gian. Verify nguồn 2026-06-26.
/// Hàm thuần theo số -> test literal được.
library;

/// Tuổi mụ (tuổi âm) = năm xem - năm sinh âm lịch + 1.
int tuoiMu(int birthLunarYear, int currentLunarYear) =>
    currentLunarYear - birthLunarYear + 1;

/// Chi (0..11) của một năm âm lịch. Tý0 Sửu1 ... Hợi11.
int yearChiIndex(int lunarYear) => (lunarYear + 8) % 12;

// ===================== KIM LÂU =====================
// Tuổi mụ chia 9, dư 1/3/6/8 = phạm (Thân/Thê/Tử/Lục Súc).

class KimLau {
  final bool pham;
  final String loai; // '', 'Thân', 'Thê', 'Tử', 'Lục Súc'
  const KimLau(this.pham, this.loai);
}

KimLau kimLau(int tuoiMu) {
  switch (tuoiMu % 9) {
    case 1:
      return const KimLau(true, 'Thân');
    case 3:
      return const KimLau(true, 'Thê');
    case 6:
      return const KimLau(true, 'Tử');
    case 8:
      return const KimLau(true, 'Lục Súc');
    default:
      return const KimLau(false, '');
  }
}

// ===================== HOANG ỐC =====================
// 6 cung; xấu = Tam Địa Sát, Ngũ Thọ Tử, Lục Hoang Ốc.
// Vị trí = (tuổiMụ÷10 - 1 + tuổiMụ%10) % 6. Đã đối chiếu danh sách tuổi tránh.

const List<String> _hoangOcCung = [
  'Nhất Cát',
  'Nhì Nghi',
  'Tam Địa Sát',
  'Tứ Tấn Tài',
  'Ngũ Thọ Tử',
  'Lục Hoang Ốc',
];
const Set<int> _hoangOcBad = {2, 4, 5};

class HoangOc {
  final String cung;
  final bool tot;
  const HoangOc(this.cung, this.tot);
}

HoangOc hoangOc(int tuoiMu) {
  final raw = (tuoiMu ~/ 10) - 1 + (tuoiMu % 10);
  final pos = ((raw % 6) + 6) % 6;
  return HoangOc(_hoangOcCung[pos], !_hoangOcBad.contains(pos));
}

// ===================== TAM TAI =====================
// Nhóm tam hợp (chi người) -> 3 năm tam tai (chi năm).
const Map<int, List<int>> _tamTai = {
  8: [2, 3, 4], 0: [2, 3, 4], 4: [2, 3, 4], // Thân Tý Thìn -> Dần Mão Thìn
  2: [8, 9, 10], 6: [8, 9, 10], 10: [8, 9, 10], // Dần Ngọ Tuất -> Thân Dậu Tuất
  5: [11, 0, 1], 9: [11, 0, 1], 1: [11, 0, 1], // Tỵ Dậu Sửu -> Hợi Tý Sửu
  11: [5, 6, 7], 3: [5, 6, 7], 7: [5, 6, 7], // Hợi Mão Mùi -> Tỵ Ngọ Mùi
};

List<int> tamTaiYears(int personChi) => _tamTai[personChi]!;
bool isTamTai(int personChi, int yearChi) =>
    _tamTai[personChi]!.contains(yearChi);

// ===================== TAM HỢP / TỨ HÀNH XUNG =====================
const List<List<int>> _tamHopGroups = [
  [8, 0, 4], // Thân Tý Thìn
  [2, 6, 10], // Dần Ngọ Tuất
  [5, 9, 1], // Tỵ Dậu Sửu
  [11, 3, 7], // Hợi Mão Mùi
];
const List<List<int>> _tuHanhXungGroups = [
  [0, 6, 3, 9], // Tý Ngọ Mão Dậu
  [4, 10, 1, 7], // Thìn Tuất Sửu Mùi
  [2, 8, 5, 11], // Dần Thân Tỵ Hợi
];

/// Các chi tam hợp với [chi] (gồm cả chính nó).
List<int> tamHopOf(int chi) =>
    _tamHopGroups.firstWhere((g) => g.contains(chi));

/// Các chi tứ hành xung với [chi] (gồm cả chính nó).
List<int> tuHanhXungOf(int chi) =>
    _tuHanhXungGroups.firstWhere((g) => g.contains(chi));

/// Chi lục xung (đối đỉnh) của [chi].
int lucXungOf(int chi) => (chi + 6) % 12;

// ===================== TỔNG HỢP LÀM NHÀ =====================
class LamNha {
  final int tuoiMu;
  final KimLau kimLau;
  final HoangOc hoangOc;
  final bool tamTai;
  const LamNha(this.tuoiMu, this.kimLau, this.hoangOc, this.tamTai);

  /// Tuổi đẹp làm nhà khi KHÔNG phạm cả 3.
  bool get tot => !kimLau.pham && hoangOc.tot && !tamTai;
}

LamNha xemTuoiLamNha(int birthLunarYear, int currentLunarYear) {
  final t = tuoiMu(birthLunarYear, currentLunarYear);
  return LamNha(t, kimLau(t), hoangOc(t),
      isTamTai(yearChiIndex(birthLunarYear), yearChiIndex(currentLunarYear)));
}
