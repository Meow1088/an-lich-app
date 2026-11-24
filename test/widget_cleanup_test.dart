import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/services/widget_service.dart';

void main() {
  final today = DateTime(2026, 11, 11);

  test('staleWidgetKeys xoá ảnh ngày đã qua, giữ hôm nay và tương lai', () {
    final keys = WidgetService.staleWidgetKeys([
      'lich_widget_image_2026-11-11.png',
      'lich_widget_image_2026-11-12.png',
      'lich_widget_2x2_image_2027-01-01.png',
      'lich_widget_image_2026-11-10.png',
      'lich_widget_2x2_image_2026-10-01.png',
    ], today);
    expect(keys, [
      'lich_widget_image_2026-11-10',
      'lich_widget_2x2_image_2026-10-01',
    ]);
  });

  test('staleWidgetKeys bỏ qua fallback, file lạ, tên ngày sai', () {
    final keys = WidgetService.staleWidgetKeys([
      'lich_widget_image.png',
      'lich_widget_2x2_image.png',
      'other.png',
      'lich_widget_image_2026-11-10.jpg',
      'lich_widget_image_2026-1-10.png',
      'lich_widget_image_2026-13-01.png',
    ], today);
    expect(keys, isEmpty);
  });
}
