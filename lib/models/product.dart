import 'package:material_ui/material_ui.dart';

/// Model produk katalog Northline
class Product {
  final String id;
  final String name;
  final String price;
  final int priceValue;
  final String description;
  final String fullDescription;
  final String imagePath;
  final bool isNetwork;
  final List<String> highlights;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.priceValue,
    required this.description,
    required this.fullDescription,
    required this.imagePath,
    this.isNetwork = false,
    this.highlights = const [],
  });

  static const List<Product> sampleProducts = [
    Product(
      id: 'prod-01',
      name: 'Northline Aero Runner',
      price: 'Rp 899.000',
      priceValue: 899000,
      description: 'Sepatu lari ringan dengan bantalan responsif untuk kenyamanan optimal setiap langkah.',
      fullDescription: 'Northline Aero Runner menghadirkan perpaduan bobot ultra-ringan dengan bantalan busa adaptif generasi terbaru. Didesain secara ergonomis untuk mendukung sirkulasi udara maksimal pada kaki, menjadikannya pilihan sempurna bagi pelari urban dan aktivitas dinamis sehari-hari.',
      imagePath: 'assets/images/product-local.jpg',
      isNetwork: false,
      highlights: [
        'Bobot ringan hanya 210 gram',
        'Upper breathable mesh berdaya tahan tinggi',
        'Outsole karet anti-slip untuk berbagai medan',
        'Bantalan busa responsif peredam benturan',
      ],
    ),
    Product(
      id: 'prod-02',
      name: 'Northline Pace Trainer',
      price: 'Rp 1.150.000',
      priceValue: 1150000,
      description: 'Dirancang untuk stabilitas dan durabilitas tinggi saat latihan intensitas harian.',
      fullDescription: 'Diformulasikan khusus untuk kebutuhan cross-training dan latihan intensif. Northline Pace Trainer menawarkan stabilitas tumit yang kokoh, grip presisi pada permukaan lantai gym, serta struktur samping yang diperkuat guna meminimalisir risiko cedera saat gerakan lateral.',
      imagePath: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600&auto=format&fit=crop&q=80',
      isNetwork: true,
      highlights: [
        'Dukungan stabilitas tumit terstruktur',
        'Konstruksi midsole kepadatan ganda',
        'Material sintetis kuat tahan gesekan',
        'Ideal untuk gym, interval run, dan latihan harian',
      ],
    ),
  ];
}

/// Item keranjang belanja
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get totalPrice => product.priceValue * quantity;
}

/// State manajemen keranjang belanja sederhana berbasis ChangeNotifier
class CartManager extends ChangeNotifier {
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  String get formattedTotalPrice {
    return 'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
