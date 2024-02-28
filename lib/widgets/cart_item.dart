import 'dart:async';

import 'package:agriplant/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../view_model/market/market_view_model.dart';

class CartItem extends StatefulWidget {
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  final Product cartItem;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int quantity; // Declare quantity variable

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItem.quantity; // Initialize quantity with product quantity
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketViewModel>(
      builder: (context, marketViewModel, child) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: const Icon(
              IconlyLight.delete,
              color: Colors.white,
              size: 25,
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            final completer = Completer<bool>();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: "Keep",
                  onPressed: () {
                    completer.complete(false);
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  },
                ),
                content: const Text(
                  "Remove from cart?",
                ),
              ),
            );
            Timer(const Duration(seconds: 3), () {
              if (!completer.isCompleted) {
                completer.complete(true);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              }
            });

            return await completer.future;
          },
          child: SizedBox(
            height: 125,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 0.1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      width: 90,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.cartItem.image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.cartItem.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Text(
                            widget.cartItem.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${widget.cartItem.price * quantity}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: ToggleButtons(
                                  borderRadius: BorderRadius.circular(99),
                                  constraints: const BoxConstraints(
                                    minHeight: 30,
                                    minWidth: 30,
                                  ),
                                  selectedColor:
                                  Theme.of(context).colorScheme.primary,
                                  isSelected: const [
                                    false,
                                    false,
                                    false,
                                  ],
                                  children: [
                                    const Icon(
                                      Icons.remove,
                                      size: 20,
                                    ),
                                    Text("$quantity"),
                                    const Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ],
                                  onPressed: (int index) {
                                    setState(() {
                                      if (index == 0 && quantity > 1) {
                                        quantity--;
                                      } else if (index == 2) {
                                        quantity++;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
