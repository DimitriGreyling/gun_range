import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/invoice_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart';

class InvoiceWidget extends ConsumerStatefulWidget {
  const InvoiceWidget({super.key});

  @override
  ConsumerState<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends ConsumerState<InvoiceWidget> {
  late Future<List<int>> _pdfFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(
          () => ref.read(invoiceProvider.notifier).generateInvoicePdf());
    });
  }

  @override
  Widget build(BuildContext context) {
    //INVOICE STATE
    final invoiceState = ref.watch(invoiceProvider);

    // ref.read(invoiceProvider.notifier).generateInvoicePdf();

    return invoiceState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : PdfViewer.data(
           invoiceState.pdfDocument ?? Uint8List(0),
            sourceName: 'Generated PDF',
            params: const PdfViewerParams(
              backgroundColor: Colors.transparent,
              pageDropShadow: BoxShadow(
                color: Colors.transparent,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(2, 2),
              ),
            ),
          );
  }
}
