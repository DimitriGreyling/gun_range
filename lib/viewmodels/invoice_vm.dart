import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/core/constants/app_details.dart';
import 'package:gun_range_app/core/constants/general_constants.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:gun_range_app/data/models/range.dart';
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
  final User _authUserProvider;

  InvoiceVm(
      {required InvoiceRepository invoiceRepository,
      required User authUserProvider})
      : _invoiceRepository = invoiceRepository,
        _authUserProvider = authUserProvider,
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

  Future<void> generateInvoicePdf({
    required Range range,
    required DateTime date,
    List<BookingGuest>? bookingGuest,
  }) async {
    state = state.copyWith(isLoading: true);

    final pdf = await _buildInvoicePdf(
      range: range,
      date: date,
      bookingGuest: bookingGuest,
    );
    final pdfBytes = await pdf.save();
    state = state.copyWith(isLoading: false, pdfDocument: pdfBytes);
  }

  Future<pw.Document> _buildInvoicePdf({
    required Range range,
    required DateTime date,
    List<BookingGuest>? bookingGuest,
  }) async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    // Example data (replace with your real data)
    const companyName = AppDetails.appName;
    const companyAddress = '123 Main St, City, Country';
    const companyContact = 'info@rangeconnect.com | +1234567890';
    final authUser = _authUserProvider;
    // const customerName = 'John Doe';
    // const customerAddress = '456 Customer Rd, City, Country';
    // const customerContact = 'john@example.com';
    final invoiceNumber = await _invoiceRepository.getNextInvoiceNumber();
    final invoiceDate = DateTime.now();
    final dueDate = invoiceDate.add(const Duration(days: 30));
    final items = [
      {'desc': 'Range Booking', 'qty': 2, 'unit': 100.0},
      {'desc': 'Competition Entry', 'qty': 1, 'unit': 150.0},
    ];
    final taxRate = 0.15; // 15%
    final paymentTerms = 'Due in 30 days';
    final bankDetails = 'Bank: Example Bank\nAccount: 123456789\nBranch: 0001';

    final subtotal = items.fold<double>(0,
        (sum, item) => sum + (item['qty'] as int) * (item['unit'] as double));
    final tax = subtotal * taxRate;
    final total = subtotal + tax;

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
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(companyName,
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text(companyAddress),
                        pw.Text(companyContact),
                      ],
                    ),
                    pw.Text('INVOICE',
                        style: pw.TextStyle(
                            fontSize: 32, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 24),
                // Invoice info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Bill To:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(authUser.userMetadata?['full_name'] ?? ''),
                        pw.Text(authUser.email ?? ''),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice #: $invoiceNumber'),
                        pw.Text(
                            'Date: ${invoiceDate.toLocal().toIso8601String().split('T').first}'),
                        pw.Text(
                            'Due: ${dueDate.toLocal().toIso8601String().split('T').first}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                // Line items table
                pw.TableHelper.fromTextArray(
                  headers: ['Description', 'Qty', 'Unit Price', 'Total'],
                  data: items
                      .map((item) => [
                            item['desc'],
                            item['qty'].toString(),
                            (item['unit'] as double).toStringAsFixed(2),
                            ((item['qty'] as int) * (item['unit'] as double))
                                .toStringAsFixed(2),
                          ])
                      .toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 24,
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                  },
                ),
                pw.SizedBox(height: 16),
                // Totals
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(children: [
                          pw.Text('Subtotal: ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(subtotal.toStringAsFixed(2)),
                        ]),
                        pw.Row(children: [
                          pw.Text('Tax (15%): ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(tax.toStringAsFixed(2)),
                        ]),
                        pw.Row(children: [
                          pw.Text('Total: ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.Text(total.toStringAsFixed(2),
                              style: pw.TextStyle(fontSize: 16)),
                        ]),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                // Payment info
                pw.Text('Payment terms: $paymentTerms'),
                pw.Text(bankDetails),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.Text('Thank you for your business!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }
}
