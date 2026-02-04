import 'package:gun_range_app/core/constants/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceRepository {
  final SupabaseClient _client;

  InvoiceRepository(this._client);

  final tableName = Tables.invoices;

  Future<String> getNextInvoiceNumber() async {
    final response = await _client.rpc('get_next_invoice_number');
    final formattedInvoiceNumber = formatInvoice(response.toString());
    return formattedInvoiceNumber;
  }

  Future<void> createInvoice(double amount) async {
    final invoiceNumber = await getNextInvoiceNumber();

    final formattedInvoiceNumber = formatInvoice(invoiceNumber);

    await _client.from(tableName).insert({
      'invoice_number': formattedInvoiceNumber,
      'amount': amount,
    });
  }

  String formatInvoice(String number) {
    return "INV-${DateTime.now().year}-${number.padLeft(6, '0')}";
  }
}
