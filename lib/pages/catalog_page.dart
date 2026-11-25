import 'package:material_ui/material_ui.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Halaman Katalog Produk Northline (Pertemuan 4)
/// Mengimplementasikan seluruh konsep praktikum A-E:
/// - Praktikum A: Text & TextStyle, batas baris, TextOverflow.ellipsis
/// - Praktikum B: Image.asset & Image.network dengan loading & errorBuilder
/// - Praktikum C: Expanded (Row 1:1) dan Flexible untuk alokasi ruang
/// - Praktikum D: Stack & Positioned pada banner promosi
/// - Praktikum E: Card, Column, dan Material 3 styling
/// Serta interaksi penuh: Lihat Produk, Masuk Keranjang, dan Checkout.
class CatalogPage extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;

  const CatalogPage({
    super.key,
    this.onToggleTheme,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final products = Product.sampleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Northline',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          if (onToggleTheme != null)
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              tooltip: isDarkMode ? 'Beralih ke mode terang' : 'Beralih ke mode gelap',
              onPressed: onToggleTheme,
            ),
          ListenableBuilder(
            listenable: CartManager.instance,
            builder: (context, _) {
              final count = CartManager.instance.totalItemCount;
              return IconButton(
                icon: Badge.count(
                  count: count,
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                tooltip: 'Keranjang belanja',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian B: Pengantar katalog
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Konsep Flexible (Praktikum C) pada hierarki teks pengantar
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temukan produk pilihan',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilihan perlengkapan yang dirancang untuk aktivitas harian.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bagian C: Banner promosi dengan Stack dan Positioned (Praktikum D)
              const PromoBanner(),
              const SizedBox(height: 28),

              // Bagian D: Header daftar produk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Konsep Flexible (Praktikum C) pada judul bagian
                  Flexible(
                    child: Text(
                      'Produk pilihan',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outline, width: 1),
                    ),
                    child: Text(
                      '${products.length} Produk',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bagian D & E: Dua kartu produk dengan LayoutBuilder adaptif
              // Pada layar cukup lebar (>= 340dp), kartu berdampingan memakai Row & Expanded (1:1)
              LayoutBuilder(
                builder: (context, constraints) {
                  final card1 = ProductCard(
                    name: products[0].name,
                    price: products[0].price,
                    description: products[0].description,
                    imagePath: products[0].imagePath,
                    isNetwork: products[0].isNetwork,
                    onViewProduct: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            product: products[0],
                          ),
                        ),
                      );
                    },
                  );

                  final card2 = ProductCard(
                    name: products[1].name,
                    price: products[1].price,
                    description: products[1].description,
                    imagePath: products[1].imagePath,
                    isNetwork: products[1].isNetwork,
                    onViewProduct: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            product: products[1],
                          ),
                        ),
                      );
                    },
                  );

                  // Jika layar sempit (< 340dp), susun vertikal agar tidak overflow
                  if (constraints.maxWidth < 340) {
                    return Column(
                      children: [
                        card1,
                        const SizedBox(height: 16),
                        card2,
                      ],
                    );
                  }

                  // Praktikum C: Dua kartu dalam Row, masing-masing Expanded(flex: 1)
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: card1,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 1,
                        child: card2,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
