import 'package:material_ui/material_ui.dart';

/// Reusable Product Card menggunakan Card dan Column (Praktikum E)
/// Memadukan Text/TextStyle (Praktikum A), Image.asset / Image.network (Praktikum B),
/// Flexible (Praktikum C), dan Material Icons bawaan.
class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final String imagePath;
  final bool isNetwork;
  final VoidCallback? onViewProduct;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.isNetwork = false,
    this.onViewProduct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewProduct,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar produk berukuran rasio 4:3 (Praktikum B)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: isNetwork ? _buildNetworkImage(context) : _buildAssetImage(context),
            ),

            // Area informasi dengan padding 14dp
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nama Produk (Praktikum A: Text & TextStyle, batas baris & ellipsis)
                  Text(
                    name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Harga Produk dengan font bold dan tabular figures
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Deskripsi Produk dengan Flexible/Text softWrap (Praktikum A & C)
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(height: 14),

                  // Tombol Aksi Utama
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onViewProduct ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Membuka detail produk: $name'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                      ),
                      label: const Text('Lihat produk'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun Image.asset dengan errorBuilder fallback
  Widget _buildAssetImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: colorScheme.surfaceContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Aset tidak ditemukan',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Membangun Image.network dengan loadingBuilder dan errorBuilder fallback
  Widget _buildNetworkImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: colorScheme.surfaceContainer,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: colorScheme.surfaceContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Gagal memuat gambar',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
