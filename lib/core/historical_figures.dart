/// "Ngày này trong lịch sử" — danh nhân sinh đúng ngày-tháng DƯƠNG LỊCH.
///
/// MỌI ngày sinh đều đã tra cứu & đối chiếu nguồn công khai (Wikipedia, báo
/// chính thống, NobelPrize...) — KHÔNG bịa. Ưu tiên danh nhân Việt Nam, bổ
/// sung danh nhân quốc tế cho các ngày trống. Chỉ gồm người có ngày sinh
/// dương lịch xác định rõ; bỏ qua người có ngày Julian/lịch nhập nhằng
/// (Newton, Bach, Beethoven, Shakespeare, Leonardo da Vinci...).
library;

class HistoricalFigure {
  final String name;
  final int birthYear;

  /// Tóm tắt 1 dòng: lĩnh vực / vai trò (quốc tế ghi kèm nước).
  final String note;

  const HistoricalFigure(this.name, this.birthYear, this.note);
}

// Khoá = tháng*100 + ngày (dương lịch). Value là List — 1 ngày nhiều người
// (ưu tiên xếp danh nhân Việt Nam trước).
const Map<int, List<HistoricalFigure>> _figures = {
  101: [HistoricalFigure('Nguyễn Chí Thanh', 1914, 'Đại tướng Quân đội Nhân dân Việt Nam')],
  108: [HistoricalFigure('Stephen Hawking', 1942, 'Nhà vật lý lý thuyết (Anh)')],
  115: [HistoricalFigure('Martin Luther King Jr.', 1929, 'Nhà hoạt động dân quyền (Mỹ)')],
  116: [HistoricalFigure('Mỹ Tâm', 1981, 'Ca sĩ — "Nữ hoàng V-pop"')],
  121: [HistoricalFigure('Nguyễn Công Phượng', 1995, 'Cầu thủ bóng đá')],
  127: [HistoricalFigure('Wolfgang Amadeus Mozart', 1756, 'Nhà soạn nhạc thiên tài (Áo)')],
  201: [HistoricalFigure('Nguyễn Văn Trỗi', 1940, 'Anh hùng lực lượng vũ trang nhân dân')],
  202: [HistoricalFigure('Xuân Diệu', 1916, 'Nhà thơ — "ông hoàng thơ tình"')],
  205: [HistoricalFigure('Cristiano Ronaldo', 1985, 'Cầu thủ bóng đá (Bồ Đào Nha)')],
  209: [HistoricalFigure('Trường Chinh', 1907, 'Tổng Bí thư, nhà lý luận')],
  211: [HistoricalFigure('Thomas Edison', 1847, 'Nhà phát minh — bóng đèn (Mỹ)')],
  212: [
    HistoricalFigure('Charles Darwin', 1809, 'Nhà tự nhiên học — thuyết tiến hoá (Anh)'),
    HistoricalFigure('Abraham Lincoln', 1809, 'Tổng thống thứ 16 Hoa Kỳ'),
  ],
  214: [HistoricalFigure('Phạm Tuân', 1947, 'Phi hành gia đầu tiên của Việt Nam')],
  224: [HistoricalFigure('Steve Jobs', 1955, 'Đồng sáng lập Apple (Mỹ)')],
  228: [HistoricalFigure('Trịnh Công Sơn', 1939, 'Nhạc sĩ')],
  301: [HistoricalFigure('Phạm Văn Đồng', 1906, 'Thủ tướng tại vị lâu năm nhất')],
  309: [HistoricalFigure('Yuri Gagarin', 1934, 'Người đầu tiên bay vào vũ trụ (Liên Xô)')],
  313: [HistoricalFigure('Lê Quang Liêm', 1991, 'Đại kiện tướng cờ vua')],
  314: [HistoricalFigure('Albert Einstein', 1879, 'Nhà vật lý — thuyết tương đối (Đức)')],
  329: [HistoricalFigure('Lê Văn Thiêm', 1918, 'Tiến sĩ Toán học đầu tiên của Việt Nam')],
  330: [HistoricalFigure('Vincent van Gogh', 1853, 'Danh họa hậu ấn tượng (Hà Lan)')],
  407: [HistoricalFigure('Lê Duẩn', 1907, 'Tổng Bí thư Đảng Cộng sản Việt Nam')],
  412: [HistoricalFigure('Nguyễn Quang Hải', 1997, 'Cầu thủ bóng đá')],
  507: [HistoricalFigure('Phạm Ngọc Thạch', 1909, 'Bộ trưởng Y tế đầu tiên')],
  510: [HistoricalFigure('Tôn Thất Tùng', 1912, 'Giáo sư, bác sĩ phẫu thuật gan')],
  519: [HistoricalFigure('Hồ Chí Minh', 1890, 'Chủ tịch nước Việt Nam Dân chủ Cộng hòa')],
  531: [HistoricalFigure('Huy Cận', 1919, 'Nhà thơ')],
  624: [HistoricalFigure('Lionel Messi', 1987, 'Cầu thủ bóng đá (Argentina)')],
  628: [HistoricalFigure('Ngô Bảo Châu', 1972, 'Giáo sư Toán — Huy chương Fields')],
  702: [HistoricalFigure('Đặng Thái Sơn', 1958, 'Nghệ sĩ piano — giải Chopin 1980')],
  705: [HistoricalFigure('Sơn Tùng M-TP', 1994, 'Ca sĩ, nhạc sĩ')],
  710: [
    HistoricalFigure('Nguyễn Tuân', 1910, 'Nhà văn'),
    HistoricalFigure('Nikola Tesla', 1856, 'Nhà phát minh điện xoay chiều (Serbia–Mỹ)'),
  ],
  718: [HistoricalFigure('Nelson Mandela', 1918, 'Tổng thống Nam Phi, chống apartheid')],
  723: [HistoricalFigure('Tạ Quang Bửu', 1910, 'Giáo sư, nhà khoa học, Bộ trưởng')],
  724: [HistoricalFigure('Trần Văn Khê', 1921, 'Giáo sư âm nhạc dân tộc')],
  820: [HistoricalFigure('Tôn Đức Thắng', 1888, 'Chủ tịch nước')],
  825: [HistoricalFigure('Võ Nguyên Giáp', 1911, 'Đại tướng, Tổng tư lệnh QĐND Việt Nam')],
  826: [HistoricalFigure('Mẹ Teresa', 1910, 'Nữ tu — Nobel Hòa bình (Macedonia)')],
  829: [HistoricalFigure('Michael Jackson', 1958, 'Ông hoàng nhạc Pop (Mỹ)')],
  901: [HistoricalFigure('Bùi Xuân Phái', 1920, 'Danh họa — "Phố Phái"')],
  913: [HistoricalFigure('Trần Đại Nghĩa', 1913, 'Giáo sư, viện sĩ ngành quân giới')],
  922: [HistoricalFigure('Hàn Mặc Tử', 1912, 'Nhà thơ')],
  927: [HistoricalFigure('Tô Hoài', 1920, 'Nhà văn — "Dế Mèn phiêu lưu ký"')],
  1002: [HistoricalFigure('Mahatma Gandhi', 1869, 'Lãnh tụ bất bạo động (Ấn Độ)')],
  1004: [HistoricalFigure('Tố Hữu', 1920, 'Nhà thơ cách mạng')],
  1005: [HistoricalFigure('Phạm Duy', 1921, 'Nhạc sĩ')],
  1006: [HistoricalFigure('Hoàng Xuân Vinh', 1974, 'Xạ thủ — HCV Olympic 2016')],
  1025: [HistoricalFigure('Pablo Picasso', 1881, 'Danh họa lập thể (Tây Ban Nha)')],
  1107: [HistoricalFigure('Marie Curie', 1867, 'Nhà khoa học — 2 giải Nobel (Ba Lan–Pháp)')],
  1109: [HistoricalFigure('Nguyễn Thị Ánh Viên', 1996, 'Kình ngư')],
  1115: [HistoricalFigure('Văn Cao', 1923, 'Nhạc sĩ — tác giả Quốc ca')],
  1126: [HistoricalFigure('Đặng Thùy Trâm', 1942, 'Anh hùng, bác sĩ — tác giả nhật ký')],
  1205: [HistoricalFigure('Walt Disney', 1901, 'Nhà làm phim hoạt hình (Mỹ)')],
  1207: [HistoricalFigure('Hoàng Tụy', 1927, 'Giáo sư Toán học')],
  1210: [HistoricalFigure('Đỗ Nhuận', 1922, 'Nhạc sĩ cách mạng')],
};

int _key(int month, int day) => month * 100 + day;

/// Danh nhân sinh đúng ngày-tháng dương lịch này (có thể rỗng).
List<HistoricalFigure> figuresOnDate(int month, int day) =>
    _figures[_key(month, day)] ?? const [];
