import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/product_grid.dart';
import '../widgets/drawer_menu.dart';
import '../models/product.dart';
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _sortOption = 'default';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  // ✅ Function to filter products based on search
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  // ✅ Function to sort products
  void _sortProducts(List<Product> products) {
    if (_sortOption == 'price_asc') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == 'price_desc') {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortOption == 'name_asc') {
      products.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("meem Shopping"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _sortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'default',
                child: Text('Default'),
              ),
              const PopupMenuItem<String>(
                value: 'price_asc',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem<String>(
                value: 'price_desc',
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem<String>(
                value: 'name_asc',
                child: Text('Name: A-Z'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for products...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "New Arrivals",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  _allProducts = snapshot.data!.docs.map((doc) {
                    return Product.fromFirestore(doc);
                  }).toList();

                  _sortProducts(_allProducts);

                  _filteredProducts = _allProducts.where((product) {
                    final query = _searchController.text.toLowerCase();
                    return product.name.toLowerCase().contains(query);
                  }).toList();

                  return ProductGrid(products: _filteredProducts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
