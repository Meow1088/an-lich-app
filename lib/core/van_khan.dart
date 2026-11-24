/// Văn khấn theo dịp (nội dung tĩnh, tham khảo theo bản phổ biến).
/// Không phải "chuẩn duy nhất" — văn khấn có nhiều dị bản theo vùng/gia đình.
library;

class VanKhan {
  final String title;
  final String dip; // dịp dùng
  final String body;
  const VanKhan(this.title, this.dip, this.body);
}

const List<VanKhan> vanKhanList = [
  VanKhan(
    'Văn khấn mùng 1 & ngày Rằm',
    'Mùng 1, ngày Rằm hằng tháng — cúng gia tiên & thần linh',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản cảnh Thành hoàng, ngài Bản xứ Thổ địa, ngài Bản gia Táo quân cùng chư vị Tôn thần.
Con kính lạy Tổ tiên, Hiển khảo, Hiển tỷ, chư vị Hương linh.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày … tháng … năm …, tín chủ con thành tâm sửa biện hương hoa, lễ vật, kim ngân, trà quả, thắp nén tâm hương dâng lên trước án.

Chúng con kính mời các ngài giáng lâm trước án, chứng giám lòng thành, thụ hưởng lễ vật, phù trì tín chủ chúng con toàn gia an lạc, công việc hanh thông, người người được chữ bình an, lộc tài vượng tiến, tâm đạo mở mang, sở cầu tất ứng, sở nguyện tòng tâm.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Thần Tài – Thổ Địa',
    'Hằng ngày & ngày vía Thần Tài (mùng 10 tháng Giêng)',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy ngài Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Đông trù Tư mệnh Táo phủ Thần quân.
Con kính lạy Thần Tài vị tiền.
Con kính lạy các ngài Thần linh, Thổ địa cai quản trong khu vực này.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày … tháng … năm …, tín chủ thành tâm sửa biện hương hoa, lễ vật, kim ngân, trà quả thắp nén tâm hương dâng lên trước án.

Chúng con kính mời ngài Thần Tài vị tiền giáng lâm trước án, chứng giám lòng thành, thụ hưởng lễ vật, phù trì cho tín chủ chúng con an ninh khang thái, vạn sự tốt lành, gia đạo hưng long thịnh vượng, lộc tài tăng tiến, tâm đạo mở mang, sở cầu tất ứng, sở nguyện tòng tâm.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Ông Công Ông Táo',
    '23 tháng Chạp — tiễn Táo Quân về trời',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy ngài Đông trù Tư mệnh Táo phủ Thần quân.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày 23 tháng Chạp năm …, tín chủ chúng con thành tâm sắm sửa hương hoa phẩm vật, xiêm hài áo mũ, kính dâng tôn thần. Thắp nén tâm hương tín chủ con thành tâm kính bái.

Chúng con kính mời ngài Đông trù Tư mệnh Táo phủ Thần quân hiển linh trước án thụ hưởng lễ vật. Cúi xin Tôn thần gia ân xá tội cho mọi lỗi lầm trong năm qua mà gia chủ chúng con đã sai phạm. Xin Tôn thần ban phước lộc, phù hộ toàn gia chúng con, trai gái, già trẻ sức khỏe dồi dào, an khang thịnh vượng, vạn sự tốt lành.

Chúng con lễ bạc tâm thành, kính lễ cầu xin, mong Tôn thần phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn gia tiên ngày giỗ',
    'Ngày giỗ (kỵ nhật) ông bà, cha mẹ',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Đức Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản gia Táo quân, chư vị Tôn thần.
Con kính lạy Tổ tiên nội ngoại, chư vị Hương linh gia tiên.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày … tháng … năm …, chính ngày giỗ của: …………………………

Năm qua tháng lại, ngày húy lâm. Tín chủ con cùng toàn gia thành tâm sắm lễ, hương hoa trà quả, thắp nén tâm hương dâng lên trước án.

Kính mời hương linh … về hâm hưởng lễ vật, chứng giám lòng thành, phù hộ độ trì cho con cháu an khang, mọi bề thuận lợi, gia đạo hưng thịnh.

Tín chủ con lại kính mời chư vị Tổ tiên nội ngoại, chư vị Hương linh cùng về hâm hưởng.

Chúng con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Tất niên',
    'Chiều 30 Tết (hoặc 29 Tết) — cúng tất niên cuối năm',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản cảnh Thành hoàng, ngài Bản xứ Thổ địa, ngài Bản gia Táo quân cùng chư vị Tôn thần.
Con kính lạy chư gia Cao Tằng Tổ khảo, Cao Tằng Tổ tỷ, Tổ tiên nội ngoại chư vị Hương linh.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày 30 tháng Chạp năm …, tín chủ con thành tâm sắm sửa hương hoa, lễ vật, cơm canh đầy đủ, kính dâng trước án, gọi là lễ Tất niên.

Chúng con kính mời chư vị Tôn thần, liệt vị Tổ tiên về chứng giám lòng thành, thụ hưởng lễ vật. Cúi xin các ngài phù hộ cho toàn gia chúng con một năm mới an khang thịnh vượng, vạn sự như ý, gia đạo hưng long, người người mạnh khỏe.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin chứng giám.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Giao thừa',
    'Đêm 30 Tết, thời khắc chuyển năm — cúng trong nhà (gia tiên)',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Đức Đương lai hạ sinh Di Lặc Tôn Phật.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản cảnh Thành hoàng, ngài Bản xứ Thổ địa, ngài Bản gia Táo quân, chư vị Tôn thần.
Con kính lạy các cụ Tổ tiên nội ngoại chư vị Hương linh.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Phút giao thừa năm cũ … sang năm mới …, tín chủ con thành tâm sửa biện hương hoa, lễ vật dâng lên trước án, kính cẩn tâu trình.

Nhân buổi tân xuân, chúng con kính mời chư vị Tôn thần, liệt vị Tổ tiên giáng lâm trước án, thụ hưởng lễ vật, chứng giám lòng thành. Cúi xin phù hộ cho toàn gia chúng con bước sang năm mới được bình an, mạnh khỏe, mọi sự hanh thông, tài lộc tấn tới, sở cầu như nguyện.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin chứng giám phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Tết Nguyên đán (mùng 1)',
    'Sáng mùng 1 Tết — cúng gia tiên ngày Tết',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Đức Đương lai hạ sinh Di Lặc Tôn Phật.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản gia Táo quân, Thổ địa, Long Mạch Tôn thần.
Con kính lạy các cụ Cao Tằng Tổ khảo, Cao Tằng Tổ tỷ, chư vị Hương linh gia tiên nội ngoại.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Nay theo tuế luật, mùng 1 tháng Giêng đầu xuân năm …, tín chủ con cùng toàn gia thành tâm sắm sửa hương hoa, phẩm vật, cơm canh, bánh mứt kính dâng trước án.

Chúng con kính mời chư vị Tôn thần và liệt vị Tổ tiên về ngự trước án, thụ hưởng lễ vật, chứng giám lòng thành. Cúi xin các ngài phù hộ độ trì cho toàn gia một năm mới an khang, thịnh vượng, con cháu hiếu thảo, học hành tấn tới, làm ăn phát đạt, vạn sự cát tường.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin chứng giám.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Nhập trạch (về nhà mới)',
    'Khi dọn về nhà mới — cáo yết Thần linh & gia tiên',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy ngài Bản cảnh Thành hoàng, ngài Bản xứ Thổ địa, ngài Định phúc Táo quân, chư vị Tôn thần cai quản trong khu vực này.
Con kính lạy Tổ tiên nội ngoại chư vị Hương linh.

Tín chủ con là: …………………………
Hôm nay là ngày … tháng … năm …, tín chủ con thành tâm sắm lễ, hương hoa trà quả, dâng lên trước án, kính cáo chư vị Tôn thần và gia tiên: nay gia đình chúng con dọn đến nhập trạch ngôi nhà tại: …………………………

Chúng con kính xin chư vị Tôn thần cho phép gia đình con được nhập về cư ngụ nơi đây, lập bát hương thờ phụng. Cúi xin các ngài và gia tiên phù hộ cho gia đạo bình an, người người mạnh khỏe, làm ăn thuận lợi, tài lộc dồi dào, vạn sự tốt lành nơi ngôi nhà mới.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
  VanKhan(
    'Văn khấn Động thổ',
    'Khi khởi công xây dựng — cúng Thổ thần, Long Mạch',
    '''Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng thiên Hậu Thổ chư vị Tôn thần.
Con kính lạy Quan Đương niên, Quan Đương cảnh.
Con kính lạy ngài Bản cảnh Thành hoàng, ngài Bản xứ Thổ địa, ngài Định phúc Táo quân, các ngài Long Mạch, Thổ thần cai quản trong khu vực này.

Tín chủ con là: …………………………
Ngụ tại: …………………………………

Hôm nay là ngày … tháng … năm …, tín chủ con thành tâm sắm lễ, hương hoa trà quả, kim ngân, dâng lên trước án. Tín chủ con xin phép được động thổ khởi công xây dựng công trình tại: …………………………

Cúi xin chư vị Tôn thần, Thổ địa, Long Mạch chứng giám lòng thành, cho phép động thổ, phù hộ cho công việc xây dựng được thuận buồm xuôi gió, mọi sự hanh thông, thợ thầy bình an, công trình bền vững, gia chủ phát tài phát lộc.

Chúng con lễ bạc tâm thành, trước án kính lễ, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)''',
  ),
];
