import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: const DrawerMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.pexels.com/photos/972887/pexels-photo-972887.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: const Text(
                "Welcome to Our Shop!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(12),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _homeCard(
                    context, Icons.local_offer, 'Best Deals', '/products'),
                _homeCard(context, Icons.star, 'Top Rated', '/products'),
                _homeCard(context, Icons.category, 'Categories', '/products'),
                _homeCard(
                    context, Icons.new_releases, 'New Arrivals', '/products'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeCard(
      BuildContext ctx, IconData icon, String title, String route) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(ctx, route),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ]),
        ),
      ),
    );
  }
}
