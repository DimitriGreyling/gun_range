import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/invoice_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceStateVm {
  bool isLoading;
  Uint8List? pdfDocument;

  InvoiceStateVm({
    this.isLoading = false,
    this.pdfDocument,
  });

  InvoiceStateVm copyWith({
    bool? isLoading,
    Uint8List? pdfDocument,
  }) {
    return InvoiceStateVm(
      isLoading: isLoading ?? this.isLoading,
      pdfDocument: pdfDocument ?? this.pdfDocument,
    );
  }
}

class InvoiceVm extends StateNotifier<InvoiceStateVm> {
  final InvoiceRepository _invoiceRepository;

  InvoiceVm({required InvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository,
        super(InvoiceStateVm(isLoading: false, pdfDocument: null));
  static pw.MemoryImage? _cachedLogo;

  String _generateInvoiceNumber({
    required String type,
    required String id,
    int? sequence,
  }) {
    final now = DateTime.now();
    final datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    final seq = sequence != null
        ? sequence.toString().padLeft(4, '0')
        : now.millisecondsSinceEpoch.toString().substring(7);
    return "$type-$id-$datePart-$seq";
  }

  Future<pw.MemoryImage> _getLogo() async {
    if (_cachedLogo != null) return _cachedLogo!;
    final logoBytes = await rootBundle.load('assets/logo/logo_no_buffer.png');
    _cachedLogo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    return _cachedLogo!;
  }

  Future<pw.Document> _buildInvoicePdf() async {
    // final logo = await _getLogo();
    // final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final invoiceNumber = await _invoiceRepository.getNextInvoiceNumber();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttf,
        italic: ttf,
        boldItalic: ttf,
      ),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Row(children: [
                  // pw.Image(logo, width: 80, height: 80),
                  pw.SizedBox(width: 16),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice Number: $invoiceNumber',
                      ),
                      pw.Text(
                        'Date: ${DateTime.now().toLocal().toIso8601String().split('T').first}',
                      ),
                      pw.Text(
                        'Range Connect',
                      ),
                    ],
                  ),
                ]),
                pw.SizedBox(height: 32),
                pw.Divider(),
                pw.SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }

  Future<void> generateInvoicePdf() async {
    state = state.copyWith(isLoading: true);

    final pdf = await _buildInvoicePdf();
    final pdfBytes = await pdf.save();
    state = state.copyWith(isLoading: false, pdfDocument: pdfBytes);
  }
}
