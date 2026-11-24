import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/bao_cao_tu_vi.dart';

/// Dựng PDF "Hồ sơ vận trình" từ [BaoCaoTuVi]. Offline hoàn toàn: font Roboto
/// (Regular/Bold/Italic/BoldItalic, hỗ trợ tiếng Việt) nhúng từ assets — KHÔNG
/// tải mạng. Bố cục: trang bìa, tóm tắt điều hành nổi bật, các mục đánh số,
/// biểu đồ thanh, hộp gợi ý màu, timeline đại vận, kết luận.
class BaoCaoPdf {
  static final _jade = PdfColor.fromInt(0xFF1E6E4F);
  static final _jadeDark = PdfColor.fromInt(0xFF154E39);
  static final _jadeTint = PdfColor.fromInt(0xFFEDF4EF); // nền panel nhạt
  static final _ink = PdfColor.fromInt(0xFF243027);
  static final _soft = PdfColor.fromInt(0xFF5B6B60);
  static final _gold = PdfColor.fromInt(0xFFB8860B);
  static final _good = PdfColor.fromInt(0xFF2E7D46);
  static final _bad = PdfColor.fromInt(0xFFB4562A);
  static final _line = PdfColor.fromInt(0xFFDDE6DE);
  static final _grey = PdfColor.fromInt(0xFFE6E6E6);

  static const _thang = [
    '', 'tháng 1', 'tháng 2', 'tháng 3', 'tháng 4', 'tháng 5', 'tháng 6',
    'tháng 7', 'tháng 8', 'tháng 9', 'tháng 10', 'tháng 11', 'tháng 12'
  ];

  /// Font PDF không có emoji → loại bỏ để tránh ô vuông tofu.
  static String _clean(String s) => s
      .replaceAll(
          RegExp(
              r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{2B00}-\u{2BFF}\u{FE0F}\u{2190}-\u{21FF}]',
              unicode: true),
          '')
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .replaceAll(RegExp(r'\n +'), '\n')
      .trim();

  static Future<Uint8List> build(BaoCaoTuVi bc) async {
    final reg =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final bold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    final italic =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Italic.ttf'));
    final boldItalic = pw.Font.ttf(
        await rootBundle.load('assets/fonts/Roboto-BoldItalic.ttf'));
    final doc = pw.Document(
        theme: pw.ThemeData.withFont(
            base: reg, bold: bold, italic: italic, boldItalic: boldItalic));

    final ten = bc.hoSo['Họ tên'] ?? 'Bạn';

    // Trang bìa.
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (ctx) => _cover(bc),
    ));

    // Nội dung. Đánh số các mục chính để dễ theo dõi.
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(42, 46, 42, 42),
      footer: (ctx) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 10),
        padding: const pw.EdgeInsets.only(top: 6),
        decoration: pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _line, width: 0.6))),
        child: pw.Text(
            'An Lịch · Hồ sơ vận trình của ${_clean(ten)} · Trang ${ctx.pageNumber}',
            style: pw.TextStyle(fontSize: 8.5, color: _soft)),
      ),
      build: (ctx) => _noiDung(bc),
    ));
    return doc.save();
  }

  /// Nội dung 11 trang (sau trang bìa) với ngắt trang THỦ CÔNG cho bố cục gọn:
  /// - 1 trang: Tóm tắt điều hành
  /// - mỗi mục chính 1 trang, RIÊNG 3 mục cuối (Phúc đức · Nghề · Kế hoạch)
  ///   gộp chung 1 trang cho đỡ trống
  /// - 1 trang cuối: Đại vận + Lời kết
  /// Tổng cộng với trang bìa = 12 trang cho lá số đầy đủ 11 mục.
  static List<pw.Widget> _noiDung(BaoCaoTuVi bc) {
    final out = <pw.Widget>[_execPanel(bc.tomTat)];
    // Gộp N mục cuối vào chung 1 trang (mặc định 3): ngắt trang trước mỗi mục
    // TRỪ hai mục áp chót/chót.
    final gomCuoi = bc.mucs.length >= 3 ? bc.mucs.length - 3 : bc.mucs.length - 1;
    for (var i = 0; i < bc.mucs.length; i++) {
      if (i <= gomCuoi) out.add(pw.NewPage());
      out.add(_mucBox(bc.mucs[i], i + 1));
    }
    out.add(pw.NewPage());
    if (bc.timeline.isNotEmpty) out.add(_timeline(bc.timeline));
    out.add(pw.SizedBox(height: 6));
    out.add(_ketLuan());
    return out;
  }

  // --- Trang bìa ---------------------------------------------------------
  static pw.Widget _cover(BaoCaoTuVi bc) {
    final now = DateTime.now();
    final ngayTao = '${now.day} ${_thang[now.month]} năm ${now.year}';
    return pw.Container(
      color: PdfColor.fromInt(0xFFF3F8F4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // Dải màu đầu trang.
          pw.Container(height: 10, color: _jade),
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(48, 56, 48, 40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 40),
                  pw.Container(width: 54, height: 5, color: _gold),
                  pw.SizedBox(height: 22),
                  pw.Text('HỒ SƠ\nVẬN TRÌNH',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 46,
                          color: _jadeDark,
                          lineSpacing: 2)),
                  pw.SizedBox(height: 10),
                  pw.Text('Bản phân tích tử vi cá nhân',
                      style: pw.TextStyle(fontSize: 15, color: _soft)),
                  pw.SizedBox(height: 40),
                  _hoSoCard(bc),
                  pw.Spacer(),
                  pw.Text('Lập ngày $ngayTao',
                      style: pw.TextStyle(fontSize: 10.5, color: _soft)),
                  pw.SizedBox(height: 12),
                  _disclaimerBox(bc.disclaimer),
                  pw.SizedBox(height: 16),
                  pw.Text('An Lịch — Lịch âm · Tử vi · Phong thủy',
                      style: pw.TextStyle(
                          fontSize: 10,
                          color: _jade,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _hoSoCard(BaoCaoTuVi bc) => pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(12),
          border: pw.Border.all(color: _line),
        ),
        child: pw.Column(
          children: [
            for (final e in bc.hoSo.entries)
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: e.key == bc.hoSo.keys.last
                        ? null
                        : pw.Border(
                            bottom: pw.BorderSide(color: _line, width: 0.5))),
                padding: const pw.EdgeInsets.symmetric(vertical: 7),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                        width: 110,
                        child: pw.Text(e.key,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                                color: _jadeDark))),
                    pw.Expanded(
                        child: pw.Text(_clean(e.value),
                            style:
                                pw.TextStyle(fontSize: 12, color: _ink))),
                  ],
                ),
              ),
          ],
        ),
      );

  static pw.Widget _disclaimerBox(String text) => pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(11),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFFCF7E8),
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: PdfColor.fromInt(0xFFEAD9A0)),
        ),
        child: pw.Text(_clean(text),
            style: pw.TextStyle(
                fontSize: 9.5, color: _soft, fontStyle: pw.FontStyle.italic)),
      );

  // --- Tóm tắt điều hành (panel nổi bật) ---------------------------------
  static pw.Widget _execPanel(BaoCaoMuc m) => pw.Container(
        padding: const pw.EdgeInsets.fromLTRB(18, 15, 18, 16),
        decoration: pw.BoxDecoration(
          color: _jadeTint,
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColor.fromInt(0xFFCFE2D6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('TÓM TẮT ĐIỀU HÀNH',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                        color: _jadeDark,
                        letterSpacing: 0.5)),
                pw.Spacer(),
                if (m.sao != null) _stars(m.sao!),
              ],
            ),
            pw.SizedBox(height: 10),
            for (final d in m.doan)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Text(_clean(d),
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                        fontSize: 12, color: _ink, lineSpacing: 2)),
              ),
            if (m.diem.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              _bars(m.diem),
            ],
          ],
        ),
      );

  // --- Chấm sao (chấm tròn) ----------------------------------------------
  static pw.Widget _stars(int n) => pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++)
            pw.Container(
              width: 9,
              height: 9,
              margin: const pw.EdgeInsets.only(left: 3),
              decoration: pw.BoxDecoration(
                  color: i < n ? _gold : _grey, shape: pw.BoxShape.circle),
            ),
          pw.SizedBox(width: 5),
          pw.Text('$n/5', style: pw.TextStyle(fontSize: 10, color: _soft)),
        ],
      );

  // --- Biểu đồ thanh -----------------------------------------------------
  static pw.Widget _bars(List<MucDiem> diem) => pw.Column(
        children: [
          for (final d in diem)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 3),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                      width: 150,
                      child: pw.Text(d.ten,
                          style: pw.TextStyle(fontSize: 11, color: _ink))),
                  pw.Stack(children: [
                    pw.Container(
                        width: 150,
                        height: 9,
                        decoration: pw.BoxDecoration(
                            color: _grey,
                            borderRadius: pw.BorderRadius.circular(5))),
                    pw.Container(
                        width: 150 * d.sao / 5,
                        height: 9,
                        decoration: pw.BoxDecoration(
                            color: d.sao >= 4
                                ? _good
                                : (d.sao <= 2 ? _bad : _gold),
                            borderRadius: pw.BorderRadius.circular(5))),
                  ]),
                  pw.SizedBox(width: 8),
                  pw.Text('${d.sao}/5',
                      style: pw.TextStyle(fontSize: 10.5, color: _soft)),
                ],
              ),
            ),
        ],
      );

  // --- Hộp gợi ý màu -----------------------------------------------------
  static pw.Widget _box(String tieuDe, List<String> items, PdfColor mau) =>
      pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(top: 8),
        padding: const pw.EdgeInsets.fromLTRB(12, 9, 12, 9),
        decoration: pw.BoxDecoration(
          // Trộn màu về phía trắng (nền nhạt, đặc) — alpha không ăn khi fill.
          color: PdfColor(mau.red * 0.13 + 0.87, mau.green * 0.13 + 0.87,
              mau.blue * 0.13 + 0.87),
          // Lưu ý: pdf assert viền không đồng đều (chỉ left) KHÔNG được có
          // borderRadius → giữ góc vuông cho hộp gợi ý.
          border: pw.Border(left: pw.BorderSide(color: mau, width: 3)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(tieuDe,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 11, color: mau)),
            pw.SizedBox(height: 3),
            for (final it in items)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text('•  ${_clean(it)}',
                    style: pw.TextStyle(
                        fontSize: 11, color: _ink, lineSpacing: 1.5)),
              ),
          ],
        ),
      );

  // --- Một mục (có số thứ tự) --------------------------------------------
  static pw.Widget _mucBox(BaoCaoMuc m, int index) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 16),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                _badge(index),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Text(m.tieuDe,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 15,
                          color: _jadeDark)),
                ),
                if (m.sao != null) _stars(m.sao!),
              ],
            ),
            pw.Divider(color: _line, height: 14, thickness: 0.6),
            for (final d in m.doan)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Text(_clean(d),
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                        fontSize: 12, color: _ink, lineSpacing: 2)),
              ),
            if (m.diem.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              _bars(m.diem),
            ],
            if (m.nen.isNotEmpty) _box('Bạn nên', m.nen, _good),
            if (m.tranh.isNotEmpty) _box('Điểm cần lưu ý', m.tranh, _bad),
          ],
        ),
      );

  /// Số thứ tự mục dạng huy hiệu tròn xanh ngọc.
  static pw.Widget _badge(int index) => pw.Container(
        width: 22,
        height: 22,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(color: _jade, shape: pw.BoxShape.circle),
        child: pw.Text(index.toString().padLeft(2, '0'),
            style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 9.5,
                fontWeight: pw.FontWeight.bold)),
      );

  // --- Timeline đại vận --------------------------------------------------
  static pw.Widget _timeline(List<MocVanHan> ts) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 16),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(children: [
              pw.Container(
                width: 22,
                height: 22,
                alignment: pw.Alignment.center,
                decoration:
                    pw.BoxDecoration(color: _gold, shape: pw.BoxShape.circle),
                child: pw.Text('~',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.Text('Đại vận theo thập niên',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                      color: _jadeDark)),
            ]),
            pw.Divider(color: _line, height: 14, thickness: 0.6),
            for (final t in ts)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                        width: 96,
                        child: pw.Text(t.tuoi,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 11,
                                color: _jade))),
                    _stars(t.sao),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                        child: pw.Text(
                            'Trọng tâm: ${t.trongTam} — ${t.nhanXet}',
                            style: pw.TextStyle(fontSize: 11, color: _ink))),
                  ],
                ),
              ),
          ],
        ),
      );

  static pw.Widget _ketLuan() => pw.Container(
        padding: const pw.EdgeInsets.all(13),
        decoration: pw.BoxDecoration(
          color: _jadeTint,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: _line),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Lời kết',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                    color: _jadeDark)),
            pw.SizedBox(height: 5),
            pw.Text(
                'Báo cáo mang tính tham khảo và định hướng để bạn hiểu thêm về '
                'chính mình. Điều quan trọng nhất vẫn là nỗ lực, lựa chọn và môi '
                'trường sống của bạn.',
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                    fontSize: 11.5,
                    color: _soft,
                    fontStyle: pw.FontStyle.italic,
                    lineSpacing: 2)),
          ],
        ),
      );
}
