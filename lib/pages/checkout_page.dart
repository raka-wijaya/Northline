import 'package:material_ui/material_ui.dart';

import '../models/product.dart';

/// Halaman Checkout dan Konfirmasi Pesanan
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _selectedPayment = 0;
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final orderId =
        'NL-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    final totalFormatted = CartManager.instance.formattedTotalPrice;

    // Bersihkan keranjang setelah berhasil checkout
    CartManager.instance.clearCart();

    setState(() {
      _isProcessing = false;
    });

    // Tampilkan dialog konfirmasi sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text('Pesanan Berhasil!', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Nomor pesanan: #$orderId\nTotal pembayaran: $totalFormatted',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Terima kasih telah berbelanja di Northline. Produk Anda akan segera disiapkan.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Kembali ke halaman katalog utama
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Kembali ke Katalog'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cart = CartManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alamat Pengiriman
              Text('Alamat Pengiriman', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Salendra Wijaya • 0812-3456-7890',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Jl. Boulevard Raya Barat No. 24, Jakarta Selatan, 12430',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ringkasan Pesanan
              Text('Ringkasan Barang', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: cart.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}× ${item.product.name}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Rp ${item.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Pilihan Metode Pembayaran
              Text('Metode Pembayaran', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_outlined,
                        color: _selectedPayment == 0
                            ? colorScheme.primary
                            : null,
                      ),
                      title: const Text('Transfer Virtual Account'),
                      subtitle: const Text('BCA, Mandiri, BNI, BRI'),
                      trailing: Icon(
                        _selectedPayment == 0
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: _selectedPayment == 0
                            ? colorScheme.primary
                            : null,
                      ),
                      onTap: () => setState(() => _selectedPayment = 0),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.qr_code_2_rounded,
                        color: _selectedPayment == 1
                            ? colorScheme.primary
                            : null,
                      ),
                      title: const Text('QRIS Instan'),
                      subtitle: const Text('Gopay, OVO, Dana, ShopeePay'),
                      trailing: Icon(
                        _selectedPayment == 1
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: _selectedPayment == 1
                            ? colorScheme.primary
                            : null,
                      ),
                      onTap: () => setState(() => _selectedPayment = 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Rincian Pembayaran
              Text('Rincian Biaya', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal Produk',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            cart.formattedTotalPrice,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Biaya Pengiriman',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'Gratis',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            cart.formattedTotalPrice,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
        ),
        child: SafeArea(
          child: FilledButton(
            onPressed: _isProcessing ? null : _processPayment,
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Bayar Sekarang • ${cart.formattedTotalPrice}'),
          ),
        ),
      ),
    );
  }
}
