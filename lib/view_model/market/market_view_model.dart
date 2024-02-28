import 'package:flutter/material.dart';
import 'package:agriplant/widgets/components/custom_shtoast.dart';
import '../../models/product.dart';

class MarketViewModel extends ChangeNotifier {
  var applyCouponButtonController = TextEditingController();

  List<Product> cart = [];

  void addToCartFromHome(Product product) {
    bool alreadyInCart = cart.any((element) => element.name == product.name);

    if (alreadyInCart) {
      toastbottomSheet('Already added to cart', color: Colors.grey);
    } else {
      cart.add(product);
      toastbottomSheet('Added to cart');
    }

    notifyListeners(); // Notify listeners of changes
  }


  void addToCartFromProductPage(Product product, int quantity) {
    bool alreadyInCart = cart.any((element) => element.name == product.name);

    if (alreadyInCart) {
      toastbottomSheet('Already added to cart', color: Colors.grey);
    } else {
      // Add the product with the specified quantity
      cart.add(Product(
        name: product.name,
        price: product.price,
        description: product.description,
        image: product.image,
        unit: product.unit,
        rating: product.rating,
        quantity: product.quantity, // Set the quantity
      ));
      toastbottomSheet('Added to cart');
    }

    notifyListeners(); // Notify listeners of changes
  }


  void removeFromCart(Product product) {
    cart.remove(product);
    notifyListeners(); // Notify listeners of changes
  }
}
