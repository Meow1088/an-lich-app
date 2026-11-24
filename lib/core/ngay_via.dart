/// Ngày vía (Phật / Bồ Tát / Thần) + lịch ăn chay. Tất cả theo ÂM LỊCH.
/// Verify nguồn 2026-06-26: Thần Tài 10/1, Quan Âm 19/2-19/6-19/9, Phật Đản 8/4,
/// Ông Táo 23/12; thập trai 1,8,14,15,18,23,24,28,29,30.
library;

class NgayVia {
  final String name;
  final int day; // ÂL
  final int month; // ÂL
  final String emoji;
  const NgayVia(this.name, this.day, this.month, this.emoji);
}

/// Các ngày vía lớn trong năm (âm lịch), sắp theo tháng/ngày.
const List<NgayVia> ngayViaList = [
  NgayVia('Vía Phật Di Lặc', 1, 1, '🙏'),
  NgayVia('Vía Ngọc Hoàng', 9, 1, '👑'),
  NgayVia('Vía Thần Tài', 10, 1, '💰'),
  NgayVia('Rằm tháng Giêng (Thượng Nguyên)', 15, 1, '🌕'),
  NgayVia('Vía Quan Âm (đản sinh)', 19, 2, '🪷'),
  NgayVia('Vía Phổ Hiền Bồ Tát', 21, 2, '🙏'),
  NgayVia('Vía Phật Đản (Thích Ca)', 8, 4, '🪷'),
  NgayVia('Vía Quan Âm (thành đạo)', 19, 6, '🪷'),
  NgayVia('Vía Đại Thế Chí Bồ Tát', 13, 7, '🙏'),
  NgayVia('Lễ Vu Lan', 15, 7, '🪷'),
  NgayVia('Vía Địa Tạng Bồ Tát', 30, 7, '🙏'),
  NgayVia('Vía Quan Âm (xuất gia)', 19, 9, '🪷'),
  NgayVia('Vía Phật Dược Sư', 30, 9, '🙏'),
  NgayVia('Vía Phật A Di Đà', 17, 11, '🪷'),
  NgayVia('Vía Thích Ca thành đạo', 8, 12, '🙏'),
  NgayVia('Vía Ông Công Ông Táo', 23, 12, '🔥'),
];

/// Ngày vía rơi đúng ngày âm (day, month) — có thể rỗng.
List<NgayVia> viaOnDate(int lunarDay, int lunarMonth) =>
    ngayViaList.where((v) => v.day == lunarDay && v.month == lunarMonth).toList();

// ===================== LỊCH ĂN CHAY =====================

enum ChayType { nhi, tu, luc, thap }

extension ChayLabel on ChayType {
  String get label => switch (this) {
        ChayType.nhi => 'Nhị trai (2 ngày)',
        ChayType.tu => 'Tứ trai (4 ngày)',
        ChayType.luc => 'Lục trai (6 ngày)',
        ChayType.thap => 'Thập trai (10 ngày)',
      };
}

const Map<ChayType, Set<int>> chayDays = {
  ChayType.nhi: {1, 15},
  ChayType.tu: {1, 14, 15, 30},
  ChayType.luc: {8, 14, 15, 23, 29, 30},
  ChayType.thap: {1, 8, 14, 15, 18, 23, 24, 28, 29, 30},
};

bool isChay(ChayType type, int lunarDay) => chayDays[type]!.contains(lunarDay);

/// Các chế độ ăn chay mà ngày âm này thuộc về (rỗng nếu không phải ngày chay).
List<ChayType> chayTypesOf(int lunarDay) =>
    ChayType.values.where((t) => isChay(t, lunarDay)).toList();
