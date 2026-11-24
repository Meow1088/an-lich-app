/// Hợp tuổi vợ chồng + tuổi xông đất (theo địa chi + ngũ hành nạp âm).
/// THAM KHẢO. Verify nguồn 2026-06-26: lục hợp (Tý-Sửu, Dần-Hợi, Mão-Tuất,
/// Thìn-Dậu, Tỵ-Thân, Ngọ-Mùi), lục hại (Tý-Mùi, Sửu-Ngọ, Dần-Tỵ, Mão-Thìn,
/// Thân-Hợi, Dậu-Tuất).
library;

import 'can_chi.dart';
import 'xem_tuoi.dart';

// Lục hợp: chi -> chi hợp.
const Map<int, int> _lucHop = {
  0: 1, 1: 0, 2: 11, 11: 2, 3: 10, 10: 3, 4: 9, 9: 4, 5: 8, 8: 5, 6: 7, 7: 6,
};
int lucHopOf(int chi) => _lucHop[chi]!;
bool isLucHop(int a, int b) => _lucHop[a] == b;

// Lục hại.
const List<List<int>> _lucHai = [
  [0, 7], [1, 6], [2, 5], [3, 4], [8, 11], [9, 10],
];
bool isLucHai(int a, int b) =>
    _lucHai.any((p) => (p[0] == a && p[1] == b) || (p[0] == b && p[1] == a));

bool isTamHopPair(int a, int b) => a != b && tamHopOf(a).contains(b);
bool isXungPair(int a, int b) => a != b && tuHanhXungOf(a).contains(b);

// Ngũ hành sinh / khắc.
const Map<String, String> _sinh = {
  'Mộc': 'Hỏa', 'Hỏa': 'Thổ', 'Thổ': 'Kim', 'Kim': 'Thủy', 'Thủy': 'Mộc',
};
const Map<String, String> _khac = {
  'Mộc': 'Thổ', 'Thổ': 'Thủy', 'Thủy': 'Hỏa', 'Hỏa': 'Kim', 'Kim': 'Mộc',
};

class HopTuoi {
  final String chiQuanHe; // mô tả quan hệ địa chi
  final int chiDiem; // +1 / 0 / -1
  final String menhQuanHe;
  final int menhDiem;
  final String ket; // Rất hợp / Hợp / Bình / Không hợp
  const HopTuoi(
      this.chiQuanHe, this.chiDiem, this.menhQuanHe, this.menhDiem, this.ket);

  int get diem => chiDiem + menhDiem;
}

HopTuoi hopTuoiVoChong(int yearA, int yearB) {
  final ca = yearChiIndex(yearA);
  final cb = yearChiIndex(yearB);

  String chiRel;
  int chiPt;
  if (isTamHopPair(ca, cb)) {
    chiRel = 'Tam hợp';
    chiPt = 1;
  } else if (isLucHop(ca, cb)) {
    chiRel = 'Lục hợp';
    chiPt = 1;
  } else if (isXungPair(ca, cb)) {
    chiRel = 'Tứ hành xung';
    chiPt = -1;
  } else if (isLucHai(ca, cb)) {
    chiRel = 'Lục hại';
    chiPt = -1;
  } else {
    chiRel = 'Bình hòa';
    chiPt = 0;
  }

  final ma = napAmOfYear(yearA).element;
  final mb = napAmOfYear(yearB).element;
  String menhRel;
  int menhPt;
  if (ma == mb) {
    menhRel = 'Bình hòa (cùng $ma)';
    menhPt = 0;
  } else if (_sinh[ma] == mb || _sinh[mb] == ma) {
    menhRel = 'Tương sinh ($ma – $mb)';
    menhPt = 1;
  } else if (_khac[ma] == mb || _khac[mb] == ma) {
    menhRel = 'Tương khắc ($ma – $mb)';
    menhPt = -1;
  } else {
    menhRel = 'Bình hòa';
    menhPt = 0;
  }

  final t = chiPt + menhPt;
  final ket = t >= 2
      ? 'Rất hợp'
      : t == 1
          ? 'Hợp'
          : t == 0
              ? 'Bình thường'
              : 'Không hợp';
  return HopTuoi(chiRel, chiPt, menhRel, menhPt, ket);
}

/// Các con giáp (chi) tốt để xông đất cho gia chủ: tam hợp + lục hợp.
List<int> chiXongDat(int chuChi) {
  final s = <int>{...tamHopOf(chuChi), lucHopOf(chuChi)}..remove(chuChi);
  return s.toList()..sort();
}
