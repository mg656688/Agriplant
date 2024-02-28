import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../view_model/market/market_view_model.dart';
import '../../widgets/cart_item.dart';
import 'checkout_page.dart'; // Import the MarketViewModel

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(context); // Access MarketViewModel from provider

    double total = 0;
    for (var cartItem in marketViewModel.cart) { // Use cart from MarketViewModel
      total += cartItem.price;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Cart", style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            marketViewModel.cart.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 160.0),
              child: Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
                : Column(
              children: [
                ...List.generate(
                  marketViewModel.cart.length, // Use cart length from MarketViewModel
                      (index) {
                    final cartItem = marketViewModel.cart[index]; // Use cart item from MarketViewModel
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: CartItem(cartItem: cartItem),
                    );
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total (${marketViewModel.cart.length} items)"), // Use cart length from MarketViewModel
                    Text(
                      "\$${total.toStringAsFixed(2)}", // Format total to display two decimal places
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // Navigate to the checkout page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  CheckoutPage()),
                      );
                    },
                    label: const Text("Proceed to Checkout"),
                    icon: const Icon(IconlyBold.arrowRight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
