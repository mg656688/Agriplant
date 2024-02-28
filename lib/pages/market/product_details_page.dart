import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../view_model/market/market_view_model.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;


  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  // Method to decrease quantity
  void decreaseQuantity() {
    if (widget.product.quantity > 1) {
      setState(() {
        widget.product.quantity--;
      });
    }
  }

  // Method to increase quantity
  void increaseQuantity() {
    setState(() {
      widget.product.quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.bookmark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.product.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            widget.product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available in stock",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "\$${widget.product.price}",
                        style: Theme.of(context).textTheme.titleLarge),
                    TextSpan(
                        text: "/${widget.product.unit}",
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.yellow.shade800,
              ),
              Text(
                "${widget.product.rating} (192)",
              ),
              const Spacer(),
              SizedBox(
                height: 30,
                width: 30,
                child: IconButton.filledTonal(
                  padding: EdgeInsets.zero,
                  onPressed: decreaseQuantity,
                  iconSize: 18,
                  icon: const Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${widget.product.quantity} ${widget.product.unit}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: IconButton.filledTonal(
                  padding: EdgeInsets.zero,
                  onPressed: increaseQuantity,
                  iconSize: 18,
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Description",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showMore
                      ? widget.product.description
                      : '${widget.product.description.substring(0, widget.product.description.length - 100)}...',
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showMore ? " Read less" : " Read more",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              // Add the current product to the cart
              Provider.of<MarketViewModel>(context, listen: false)
                  .addToCartFromProductPage(widget.product, widget.product.quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to cart'),
                ),
              );
            },
            icon: const Icon(IconlyLight.bag2),
            label: const Text("Add to cart"),
          )
        ],
      ),
    );
  }
}
