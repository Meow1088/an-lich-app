/// Dữ liệu DIỄN GIẢI tử vi: Tứ Hóa + chuyển trạng thái sao (Miếu/Vượng/Hãm…)
/// sang ngôn ngữ đời thường cho chế độ Cơ bản.
library;

/// Ý nghĩa Tứ Hóa.
const Map<String, String> tuHoaYNghia = {
  'Hóa lộc': 'Hóa Lộc — tài lộc, may mắn, thuận lợi; tăng sức tốt cho cung.',
  'Hóa quyền': 'Hóa Quyền — quyền lực, năng lực, sự chủ động và thăng tiến.',
  'Hóa khoa': 'Hóa Khoa — danh tiếng, thi cử, quý nhân, tiếng thơm.',
  'Hóa kỵ': 'Hóa Kỵ — trắc trở, vướng mắc, hao tổn; cần thận trọng ở cung này.',
};

/// Giải nghĩa kỹ thuật trạng thái sao (chế độ Chuyên sâu).
const Map<String, String> dacTinhNghia = {
  'Miếu': 'rất mạnh',
  'Vượng': 'mạnh',
  'Đắc': 'tốt',
  'Bình': 'bình thường',
  'Hãm': 'suy yếu',
};

/// Trạng thái sao bằng ngôn ngữ đời thường (chế độ Cơ bản) — tránh thuật ngữ.
const Map<String, String> _trangThaiCoBan = {
  'Miếu': 'Rất mạnh',
  'Vượng': 'Mạnh',
  'Đắc': 'Khá tốt',
  'Bình': 'Bình thường',
  'Hãm': 'Ảnh hưởng giảm',
};

/// Đổi trạng thái kỹ thuật sang nhãn đời thường; fallback giữ nguyên nếu lạ.
String trangThaiCoBan(String dacTinh) => _trangThaiCoBan[dacTinh] ?? dacTinh;
