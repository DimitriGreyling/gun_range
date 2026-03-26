import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/repository_providers.dart';
import 'package:gun_range_app/viewmodels/invoice_vm.dart';

final invoiceProvider = StateNotifierProvider<InvoiceVm, InvoiceStateVm>(
  (ref) {
    final invoiceRepository = ref.watch(invoiceRepositoryProvider);
    final authUser = ref.watch(authUserProvider).value!;
    return InvoiceVm(
      invoiceRepository: invoiceRepository,
      authUserProvider: authUser,
    );
  },
);
