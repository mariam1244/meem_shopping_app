import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
