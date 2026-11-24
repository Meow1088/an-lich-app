/// Thần số học (numerology) — số chủ đạo từ ngày sinh DƯƠNG LỊCH.
/// Cộng toàn bộ chữ số ngày/tháng/năm, rút gọn về 1 chữ số; giữ số bậc thầy 11, 22.
/// Nội dung diễn giải mang tính tham khảo / giải trí.
library;

int _sumDigits(int n) {
  var s = 0;
  var x = n;
  while (x > 0) {
    s += x % 10;
    x ~/= 10;
  }
  return s;
}

/// Số chủ đạo (1..9, hoặc 11, 22).
int soChuDao(int day, int month, int year) {
  var total = _sumDigits(day) + _sumDigits(month) + _sumDigits(year);
  while (total > 9 && total != 11 && total != 22) {
    total = _sumDigits(total);
  }
  return total;
}

class ThanSo {
  final int so;
  final String tieuDe;
  final String tongQuan;
  final String diemManh;
  final String diemYeu;
  final String suNghiep;
  final String loiKhuyen;
  const ThanSo(this.so, this.tieuDe, this.tongQuan, this.diemManh,
      this.diemYeu, this.suNghiep, this.loiKhuyen);
}

const Map<int, ThanSo> _data = {
  1: ThanSo(
    1,
    'Số 1 — Người lãnh đạo',
    'Số 1 mang năng lượng khởi đầu, độc lập và tiên phong. Bạn sinh ra để dẫn đầu, có ý chí mạnh mẽ, quyết đoán và luôn muốn tạo dấu ấn riêng. Không thích bị phụ thuộc hay đi theo lối mòn.',
    'Tự tin, sáng tạo, dám nghĩ dám làm, có khả năng lãnh đạo và truyền động lực cho người khác.',
    'Đôi khi bảo thủ, cứng đầu, dễ độc đoán hoặc nóng vội; ngại lắng nghe ý kiến trái chiều.',
    'Hợp vai trò lãnh đạo, khởi nghiệp, quản lý, làm chủ — nơi bạn được tự chủ và quyết định.',
    'Học cách lắng nghe và hợp tác; kiên nhẫn với người khác sẽ giúp bạn đi xa hơn.',
  ),
  2: ThanSo(
    2,
    'Số 2 — Người hòa giải',
    'Số 2 mang năng lượng của sự cân bằng, nhạy cảm và hợp tác. Bạn tinh tế, biết lắng nghe, giỏi dung hòa các mối quan hệ và thường là chỗ dựa tinh thần cho người xung quanh.',
    'Khéo léo, ngoại giao tốt, đồng cảm, kiên nhẫn và biết cách làm việc nhóm.',
    'Dễ tự ti, ngại va chạm, hay lo nghĩ và phụ thuộc cảm xúc vào người khác.',
    'Hợp công việc cần phối hợp, tư vấn, nhân sự, ngoại giao, chăm sóc, nghệ thuật.',
    'Hãy tin vào giá trị bản thân và dám nói lên chính kiến; đừng hi sinh quá mức.',
  ),
  3: ThanSo(
    3,
    'Số 3 — Người sáng tạo',
    'Số 3 mang năng lượng sáng tạo, lạc quan và giao tiếp. Bạn vui vẻ, giàu trí tưởng tượng, có duyên ăn nói và lan tỏa năng lượng tích cực cho mọi người.',
    'Sáng tạo, hoạt ngôn, hài hước, truyền cảm hứng và thích nghi nhanh.',
    'Dễ phân tán, thiếu kiên trì, hay cả thèm chóng chán và ngại việc lặp lại nhàm chán.',
    'Hợp nghệ thuật, viết lách, truyền thông, MC, marketing, giảng dạy, biểu diễn.',
    'Tập trung vào một mục tiêu và theo đến cùng; kỷ luật sẽ biến tài năng thành thành tựu.',
  ),
  4: ThanSo(
    4,
    'Số 4 — Người kiến tạo',
    'Số 4 mang năng lượng của sự ổn định, kỷ luật và thực tế. Bạn chăm chỉ, đáng tin cậy, làm việc có phương pháp và xây dựng mọi thứ một cách bền vững.',
    'Cần cù, có trách nhiệm, kiên trì, tỉ mỉ và rất đáng tin.',
    'Hơi cứng nhắc, ngại thay đổi, dễ bảo thủ và đôi khi quá lo xa.',
    'Hợp kỹ thuật, tài chính, kế toán, xây dựng, quản lý vận hành, công việc đòi hỏi sự chính xác.',
    'Cho phép bản thân linh hoạt và đón nhận cái mới; nghỉ ngơi đúng lúc để tránh kiệt sức.',
  ),
  5: ThanSo(
    5,
    'Số 5 — Người tự do',
    'Số 5 mang năng lượng của tự do, phiêu lưu và thay đổi. Bạn năng động, ưa khám phá, thích trải nghiệm và không chịu được sự gò bó.',
    'Linh hoạt, thích nghi tốt, giao tiếp rộng, nhạy bén với cơ hội mới.',
    'Dễ chán, thiếu kiên định, ham vui và đôi khi liều lĩnh, khó cam kết lâu dài.',
    'Hợp kinh doanh, du lịch, bán hàng, truyền thông, công việc đi lại nhiều và tự do giờ giấc.',
    'Học cách cam kết và hoàn thành; tự do thực sự đến từ kỷ luật bản thân.',
  ),
  6: ThanSo(
    6,
    'Số 6 — Người chăm sóc',
    'Số 6 mang năng lượng của tình yêu thương, trách nhiệm và gia đình. Bạn giàu lòng vị tha, luôn quan tâm người khác và đề cao sự hài hòa, ấm áp.',
    'Tận tụy, trách nhiệm, ấm áp, biết hi sinh và tạo cảm giác an toàn cho mọi người.',
    'Dễ ôm đồm, lo lắng thái quá cho người khác mà quên bản thân; đôi khi quá cầu toàn.',
    'Hợp y tế, giáo dục, dịch vụ, chăm sóc, ẩm thực, công việc liên quan đến con người và gia đình.',
    'Hãy yêu thương bản thân như yêu thương người khác; đặt ra giới hạn lành mạnh.',
  ),
  7: ThanSo(
    7,
    'Số 7 — Người trí tuệ',
    'Số 7 mang năng lượng của trí tuệ, chiều sâu và tâm linh. Bạn thích suy ngẫm, nghiên cứu, tìm hiểu bản chất sự vật và sống thiên về nội tâm.',
    'Sâu sắc, thông minh, độc lập trong tư duy, có trực giác và khả năng phân tích tốt.',
    'Dễ khép kín, hoài nghi, sống xa cách và đôi khi cô đơn vì ít chia sẻ cảm xúc.',
    'Hợp nghiên cứu, khoa học, phân tích, công nghệ, tâm lý, triết học, tâm linh.',
    'Mở lòng chia sẻ và kết nối với mọi người; cân bằng giữa lý trí và cảm xúc.',
  ),
  8: ThanSo(
    8,
    'Số 8 — Người quyền lực',
    'Số 8 mang năng lượng của quyền lực, tham vọng và tài chính. Bạn có bản lĩnh, giỏi tổ chức, khao khát thành công vật chất và khả năng lãnh đạo mạnh mẽ.',
    'Quyết đoán, giỏi kinh doanh và quản lý tiền bạc, có chí tiến thủ và sức ảnh hưởng lớn.',
    'Dễ tham công tiếc việc, đặt nặng vật chất, đôi khi độc đoán và áp lực với bản thân lẫn người khác.',
    'Hợp kinh doanh, tài chính, đầu tư, quản trị, lãnh đạo doanh nghiệp, bất động sản.',
    'Cân bằng giữa sự nghiệp và đời sống tinh thần; dùng quyền lực một cách rộng lượng.',
  ),
  9: ThanSo(
    9,
    'Số 9 — Người nhân ái',
    'Số 9 mang năng lượng của lòng nhân ái, lý tưởng và sự bao dung. Bạn sống vì cộng đồng, giàu lòng trắc ẩn và luôn hướng tới những giá trị lớn lao.',
    'Vị tha, rộng lượng, giàu lý tưởng, có sức hút và tinh thần cống hiến.',
    'Dễ mơ mộng, lý tưởng hóa, ôm đồm chuyện thiên hạ và khó dứt bỏ quá khứ.',
    'Hợp hoạt động xã hội, từ thiện, giáo dục, nghệ thuật, y tế, công việc giúp đỡ con người.',
    'Học cách buông bỏ và chăm lo cho chính mình; lý tưởng cần đi cùng hành động thực tế.',
  ),
  11: ThanSo(
    11,
    'Số 11 — Bậc thầy trực giác',
    'Số 11 là số bậc thầy, mang năng lượng trực giác mạnh mẽ và khả năng truyền cảm hứng. Bạn nhạy bén, có chiều sâu tâm linh và tiềm năng tỏa sáng phi thường.',
    'Trực giác sắc bén, giàu cảm hứng, sáng tạo, nhạy cảm và có sức ảnh hưởng tinh thần.',
    'Dễ căng thẳng, nhạy cảm thái quá, áp lực lớn từ kỳ vọng và dao động cảm xúc.',
    'Hợp lĩnh vực truyền cảm hứng: nghệ thuật, tâm linh, cố vấn, diễn thuyết, sáng tạo.',
    'Học cách giữ cân bằng và làm chủ cảm xúc; tin vào trực giác nhưng đừng tự tạo áp lực.',
  ),
  22: ThanSo(
    22,
    'Số 22 — Kiến trúc sư bậc thầy',
    'Số 22 là số bậc thầy quyền năng nhất, kết hợp tầm nhìn lớn của số 11 với khả năng thực thi của số 4. Bạn có thể biến những giấc mơ lớn thành hiện thực.',
    'Tầm nhìn xa, thực tế, bản lĩnh, khả năng tổ chức và hiện thực hóa dự án quy mô lớn.',
    'Áp lực rất lớn, dễ quá tải, cầu toàn và đôi khi bị choáng ngợp bởi chính tham vọng của mình.',
    'Hợp lãnh đạo dự án lớn, kiến trúc, kỹ thuật quy mô, doanh nghiệp tầm cỡ, công trình xã hội.',
    'Chia mục tiêu lớn thành các bước nhỏ; kiên nhẫn và giữ sức khỏe để đi đường dài.',
  ),
};

ThanSo thanSoOf(int so) => _data[so] ?? _data[1]!;
