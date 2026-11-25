import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:northline/main.dart';
import 'package:northline/models/product.dart';
import 'package:northline/pages/cart_page.dart';
import 'package:northline/pages/checkout_page.dart';
import 'package:northline/pages/product_detail_page.dart';
import 'package:northline/widgets/product_card.dart';
import 'package:northline/widgets/promo_banner.dart';

void main() {
  setUp(() {
    CartManager.instance.clearCart();
  });

  testWidgets('Katalog Produk Northline smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NorthlineApp());
    await tester.pumpAndSettle();

    // Verifikasi identitas toko
    expect(find.text('Northline'), findsOneWidget);

    // Verifikasi pengantar katalog (Praktikum A: Text & TextStyle)
    expect(find.text('Temukan produk pilihan'), findsOneWidget);
    expect(
      find.text('Pilihan perlengkapan yang dirancang untuk aktivitas harian.'),
      findsOneWidget,
    );

    // Verifikasi banner promosi (Praktikum D: Stack & Positioned)
    expect(find.byType(PromoBanner), findsOneWidget);
    expect(find.text('Koleksi Terbaru'), findsOneWidget);

    // Verifikasi judul bagian dan jumlah produk
    expect(find.text('Produk pilihan'), findsOneWidget);
    expect(find.text('2 Produk'), findsOneWidget);

    // Verifikasi kedua kartu produk (Praktikum E: Card & Column, Praktikum C: Expanded)
    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(find.text('Northline Aero Runner'), findsOneWidget);
    expect(find.text('Northline Pace Trainer'), findsOneWidget);
    expect(find.text('Rp 899.000'), findsOneWidget);
    expect(find.text('Rp 1.150.000'), findsOneWidget);
    expect(find.text('Lihat produk'), findsNWidgets(2));
  });

  testWidgets('Alur interaksi lengkap: Lihat Produk -> Masuk Keranjang -> Checkout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NorthlineApp());
    await tester.pumpAndSettle();

    // 1. Klik "Lihat produk" pada kartu pertama (Northline Aero Runner)
    final firstProductButton = find.text('Lihat produk').first;
    await tester.tap(firstProductButton);
    await tester.pumpAndSettle();

    // Verifikasi berpindah ke ProductDetailPage
    expect(find.byType(ProductDetailPage), findsOneWidget);
    expect(find.text('Tentang Produk'), findsOneWidget);
    expect(find.text('Fitur Utama'), findsOneWidget);

    // 2. Tambah produk ke keranjang
    final addToCartButton = find.text('Ke Keranjang');
    expect(addToCartButton, findsOneWidget);
    await tester.tap(addToCartButton);
    await tester.pump();

    // Verifikasi notifikasi SnackBar muncul
    expect(find.byType(SnackBar), findsOneWidget);
    expect(CartManager.instance.totalItemCount, 1);

    // 3. Masuk ke halaman keranjang belanja
    final cartIconButton = find.byTooltip('Keranjang belanja').first;
    await tester.tap(cartIconButton);
    await tester.pumpAndSettle();

    // Verifikasi berada di CartPage
    expect(find.byType(CartPage), findsOneWidget);
    expect(find.text('Northline Aero Runner'), findsOneWidget);
    expect(find.text('Total Harga'), findsOneWidget);

    // 4. Klik tombol Checkout
    final checkoutButton = find.text('Checkout');
    expect(checkoutButton, findsOneWidget);
    await tester.tap(checkoutButton);
    await tester.pumpAndSettle();

    // Verifikasi berada di CheckoutPage
    expect(find.byType(CheckoutPage), findsOneWidget);
    expect(find.text('Alamat Pengiriman'), findsOneWidget);
    expect(find.text('Metode Pembayaran'), findsOneWidget);
    expect(find.text('Rincian Biaya'), findsOneWidget);

    // 5. Klik Bayar Sekarang
    final payButton = find.byType(FilledButton).last;
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    // Verifikasi dialog pesanan sukses muncul dan keranjang kosong
    expect(find.text('Pesanan Berhasil!'), findsOneWidget);
    expect(CartManager.instance.totalItemCount, 0);

    // Klik tombol Kembali ke Katalog
    final backButton = find.text('Kembali ke Katalog');
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verifikasi kembali ke halaman awal (CatalogPage)
    expect(find.text('Temukan produk pilihan'), findsOneWidget);
  });
}
