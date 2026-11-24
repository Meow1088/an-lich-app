/// Dữ liệu diễn giải Tử vi — CHẾ ĐỘ CƠ BẢN.
///
/// Viết như một phân tích tính cách bằng ngôn ngữ đời thường, hạn chế tối đa
/// thuật ngữ tử vi (theo góp ý người dùng: người phổ thông cần đọc hiểu ngay,
/// không cần biết "Tả Hữu", "Miếu", "đắc địa"…).
///
/// Nội dung diễn đạt lại theo tính chất 14 chính tinh cổ truyền phổ biến, mang
/// tính THAM KHẢO / tự khám phá bản thân, không phải khẳng định về tương lai.
/// Tên chính tinh KHỚP catalog `tu_vi.dart` (vd 'Thái Dương' hoa chữ D).
library;

/// Mô tả kiểu-AI cho một chính tinh khi tọa cung Mệnh.
class MenhCoBan {
  final String tinhCach; // 2-3 câu, không thuật ngữ
  final String tinhCam; // 1-2 câu
  const MenhCoBan(this.tinhCach, this.tinhCam);
}

const Map<String, MenhCoBan> menhCoBan = {
  'Tử vi': MenhCoBan(
    'Bạn thích tự mình quyết định thay vì bị người khác chỉ đạo. Bạn làm việc '
        'có kế hoạch, có trách nhiệm và muốn mọi thứ rõ ràng. Người xung quanh '
        'thường thấy ở bạn khí chất của người dẫn dắt, đáng tin cậy.',
    'Bạn yêu nghiêm túc, ít nói lời hoa mỹ nhưng quan tâm bằng hành động. Nếu '
        'cả hai đều muốn giữ quan điểm riêng thì dễ căng thẳng, nên tập nhường '
        'nhịn và lắng nghe nhau.',
  ),
  'Thiên cơ': MenhCoBan(
    'Bạn thông minh, nhanh nhạy và thích tìm hiểu cái mới. Bạn giỏi tính toán, '
        'xoay xở và thích nghi với thay đổi. Điểm cần chú ý là đôi khi bạn suy '
        'nghĩ hơi nhiều và hay đổi ý.',
    'Trong tình cảm bạn khá tinh tế và chu đáo, nhưng dễ đắn đo. Khi đã chọn '
        'được người hợp, bạn nên kiên định để mối quan hệ ổn định.',
  ),
  'Thái Dương': MenhCoBan(
    'Bạn cởi mở, nhiệt tình và sẵn lòng giúp đỡ người khác. Bạn thẳng thắn, '
        'rộng rãi và thích đứng ra gánh vác việc chung. Đôi khi bạn lo cho '
        'người khác nhiều đến mức quên chăm sóc bản thân.',
    'Bạn yêu chân thành và bao dung. Chỉ cần bớt nóng và bớt ôm đồm, chuyện '
        'tình cảm sẽ nhẹ nhàng hơn nhiều.',
  ),
  'Vũ khúc': MenhCoBan(
    'Bạn thực tế, quyết đoán và có ý chí mạnh. Bạn giỏi chuyện tiền bạc, làm '
        'việc gì cũng muốn tới nơi tới chốn. Điểm cần lưu ý là bạn hơi cứng và '
        'ít thể hiện cảm xúc ra ngoài.',
    'Bạn thể hiện tình cảm bằng sự chăm lo thiết thực hơn là lời ngọt ngào. '
        'Hãy mềm mỏng hơn để người bên cạnh cảm nhận được sự ấm áp của bạn.',
  ),
  'Thiên đồng': MenhCoBan(
    'Bạn hiền hòa, lạc quan và dễ chịu, ít khi để bụng chuyện gì lâu. Bạn biết '
        'tận hưởng cuộc sống và thường gặp may về sau. Điểm cần chú ý là đôi '
        'khi bạn hơi ngại khó, thích an nhàn.',
    'Bạn tình cảm, dễ gần và mong một mái ấm êm đềm. Chỉ cần chủ động và cố '
        'gắng hơn một chút, hạnh phúc sẽ bền lâu.',
  ),
  'Liêm trinh': MenhCoBan(
    'Bạn có cá tính mạnh, làm việc theo nguyên tắc và giàu nghị lực. Bạn đa '
        'tài, lúc rất nghiêm túc, lúc lại phóng khoáng. Cuộc sống của bạn '
        'thường có lúc thăng lúc trầm rõ rệt.',
    'Chuyện tình cảm của bạn nhiều màu sắc và có thể sôi nổi. Khi đã gắn bó '
        'thì nên chung thủy và rõ ràng để tránh rắc rối.',
  ),
  'Thiên phủ': MenhCoBan(
    'Bạn chín chắn, đôn hậu và biết lo xa. Bạn thích sự ổn định, giỏi tích lũy '
        'và sắp xếp mọi việc. Đôi khi bạn hơi thận trọng, ngại mạo hiểm và '
        'tính toán khá kỹ.',
    'Bạn coi trọng gia đình và sự bền vững. Bạn là chỗ dựa đáng tin, mang lại '
        'cảm giác an toàn cho người bên cạnh.',
  ),
  'Thái âm': MenhCoBan(
    'Bạn dịu dàng, tinh tế và giàu tình cảm. Bạn có mắt thẩm mỹ, để ý đến cảm '
        'xúc của người khác và làm việc chu đáo. Điểm cần chú ý là bạn hay suy '
        'nghĩ, đôi khi thiếu quyết đoán.',
    'Bạn yêu sâu sắc và lãng mạn, rất trân trọng người mình thương. Hãy tự tin '
        'hơn vào quyết định của mình để bớt lo nghĩ.',
  ),
  'Tham lang': MenhCoBan(
    'Bạn năng động, đa tài và giỏi giao tiếp. Bạn thích trải nghiệm, nắm bắt '
        'cơ hội nhanh và biết cách tạo quan hệ. Điểm cần chú ý là mong muốn của '
        'bạn khá nhiều, dễ bị phân tâm.',
    'Bạn có sức hút và đời sống tình cảm phong phú. Biết giữ chừng mực thì tình '
        'cảm sẽ đẹp và lâu dài.',
  ),
  'Cự môn': MenhCoBan(
    'Bạn ăn nói giỏi, lý luận sắc bén và thích tìm hiểu tới cùng. Bạn phù hợp '
        'những việc dùng lời nói hoặc nghiên cứu. Điểm cần chú ý là lời nói đôi '
        'khi dễ gây hiểu lầm nên bạn hay vướng thị phi.',
    'Trong tình cảm bạn nên nói chuyện thẳng thắn nhưng nhẹ nhàng. Lắng nghe '
        'nhiều hơn sẽ giúp tránh những tranh cãi không đáng có.',
  ),
  'Thiên tướng': MenhCoBan(
    'Bạn trung thực, công bằng và thích giúp đỡ mọi người. Bạn đáng tin cậy, '
        'coi trọng lễ nghĩa và làm việc có trước có sau. Đôi khi bạn hơi cả nể '
        'và thiếu chủ kiến.',
    'Bạn chăm sóc bạn đời chu đáo, sống hài hòa và tương kính. Hãy mạnh dạn nói '
        'ra mong muốn của mình thay vì luôn chiều theo người khác.',
  ),
  'Thiên lương': MenhCoBan(
    'Bạn chính trực, nhân hậu và chững chạc hơn tuổi. Bạn hay đứng ra che chở, '
        'giúp người khác vượt qua khó khăn. Điểm cần chú ý là đôi khi bạn hơi '
        'bảo thủ và lo xa.',
    'Bạn là người đáng nương tựa, mang lại cảm giác an tâm. Trong tình cảm nên '
        'cởi mở hơn, tránh áp đặt suy nghĩ của mình lên đối phương.',
  ),
  'Thất sát': MenhCoBan(
    'Bạn mạnh mẽ, độc lập và dám nghĩ dám làm. Bạn không ngại khó, thích tự '
        'mình bươn chải và có bản lĩnh. Cuộc đời bạn thường nhiều thử thách '
        'nhưng cũng nhiều cơ hội bứt phá.',
    'Bạn cá tính và có phần khó gần lúc đầu. Kết hôn muộn một chút và học cách '
        'chia sẻ sẽ giúp tình cảm bền hơn.',
  ),
  'Phá quân': MenhCoBan(
    'Bạn gan dạ, thích đổi mới và không ưa gò bó. Bạn sẵn sàng làm lại từ đầu '
        'và dám thử điều người khác e ngại. Cuộc sống của bạn thường nhiều thay '
        'đổi lớn.',
    'Tình cảm của bạn có thể nhiều biến động. Nếu chọn được người bao dung và '
        'cùng bạn thích nghi, gắn bó về sau sẽ vững vàng.',
  ),
};
