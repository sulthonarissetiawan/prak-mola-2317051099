import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product_utils/product_utils.dart';
import '../services/favorite_product_service.dart';

class PackageDemoView extends StatefulWidget {
  const PackageDemoView({super.key});

  @override
  State<PackageDemoView> createState() => _PackageDemoViewState();
}

class _PackageDemoViewState extends State<PackageDemoView> {
  final TextEditingController _productController = TextEditingController();
  final FavoriteProductService _favoriteService = FavoriteProductService();

  String? _favoriteProduct;
  String? _message;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    try {
      final saved = await _favoriteService.getFavorite();
      if (!mounted) return;
      setState(() {
        _favoriteProduct = saved;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Gagal memuat produk favorit: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveFavorite() async {
    final nama = _productController.text.trim();
    if (nama.isEmpty) {
      setState(() {
        _message = 'Masukkan nama produk terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _favoriteService.saveFavorite(nama);
      if (!mounted) return;
      setState(() {
        _favoriteProduct = nama;
        _message = 'Produk favorit berhasil disimpan.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Gagal menyimpan favorit: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeFavorite() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _favoriteService.removeFavorite();
      if (!mounted) return;
      setState(() {
        _favoriteProduct = null;
        _productController.clear();
        _message = 'Produk favorit berhasil dihapus.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Gagal menghapus favorit: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Package lokal product_utils
    final namaProduk = formatNamaProduk(
      'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
    );
    const double hargaProduk = 109.95;
    const double diskon = 10;
    final hargaDiskon = hitungHargaDiskon(hargaProduk, diskon);

    // Package intl untuk format dolar
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    final tanggal = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final namaFavorit = _favoriteProduct == null
        ? 'Belum ada'
        : formatNamaProduk(_favoriteProduct!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk Interaktif'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN INFORMASI PRODUK
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined),
                        SizedBox(width: 10),
                        Text(
                          'Informasi Produk',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      namaProduk,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Contoh produk dari katalog FakeStore API',
                    ),
                    const Divider(height: 35),
                    Text(
                      'Harga Normal: ${formatter.format(hargaProduk)}',
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Diskon: ${diskon.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Harga Diskon: ${formatter.format(hargaDiskon)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Tanggal: $tanggal',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // BAGIAN PRODUK FAVORIT
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Produk Favorit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Masukkan nama produk yang ingin disimpan sebagai favorit.',
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Produk Favorit: $namaFavorit',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _productController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Produk Favorit',
                        prefixIcon: Icon(Icons.shopping_bag),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveFavorite,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Favorit'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _removeFavorite,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus Favorit'),
                    ),
                    if (_message != null) ...[
                      const SizedBox(height: 16),
                      Text(_message!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
