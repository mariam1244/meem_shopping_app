import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        body: const Center(
          child: Text("Please login to view your orders."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('You have no past orders.'),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              try {
                final orderData = order.data() as Map<String, dynamic>;
                final orderDate = (orderData['date'] as Timestamp?)?.toDate();
                final orderTotal =
                    (orderData['total'] as num?)?.toDouble() ?? 0.0;
                final orderItems = (orderData['items'] as List<dynamic>?) ?? [];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text("Order ID: ${order.id.substring(0, 8)}..."),
                    subtitle: Text(
                        "Date: ${orderDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
                    trailing: Text("\$${orderTotal.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    children: orderItems.map((item) {
                      if (item is Map<String, dynamic>) {
                        try {
                          final product = Product.fromJson(item);
                          return ListTile(
                            leading: Image.network(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.name),
                            subtitle: Text("Quantity: ${product.quantity}"),
                            trailing:
                                Text("\$${product.price.toStringAsFixed(2)}"),
                          );
                        } catch (e) {
                          return ListTile(
                            title: Text(
                                'Error loading product: ${item['name'] ?? 'Unknown'}'),
                            subtitle: Text('Data format error.'),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                );
              } catch (e) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Error loading order: ${order.id}'),
                    subtitle:
                        Text('Data format error. Please contact support.'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
