import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

final List<CartItem> cartItems = [];
final List<Order> orders = [];
final List<Product> wishlist = [];

void addToCart(Product product, int qty) {
  final idx = cartItems.indexWhere((c) => c.product.id == product.id);
  if (idx >= 0) {
    cartItems[idx].quantity += qty;
  } else {
    cartItems.add(CartItem(product: product, quantity: qty));
  }
}

double get cartTotal => cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

void confirmOrder() {
  if (cartItems.isEmpty) return;
  orders.add(Order(
    items: cartItems
        .map((e) => CartItem(product: e.product, quantity: e.quantity))
        .toList(),
    total: cartTotal,
  ));
  cartItems.clear();
}
