import 'package:coflow_app/core/components/buttons/custom_elevated_button.dart';
import 'package:coflow_app/core/components/cart_tile/cart_tile.dart';

import '../../services/database_service.dart';

import '../../models/product_model.dart';
import 'package:flutter/material.dart';
import '../../../core/extension/context_extension.dart';

class ShoppingCartView extends StatelessWidget {
  ShoppingCartView({Key? key}) : super(key: key);

  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseService.userCartReference.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        List productList = data["productList"] ?? [];
        return Padding(
          padding: context.paddingMedium,
          child: Column(
            children: [
              if (productList.isEmpty)
                ...buildEmptyCart(context)
              else ...[
                Expanded(
                  flex: 2,
                  child: buildCartHeader(context),
                ),
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 18,
                  child: buildCart(productList),
                ),
                // Text("total:${data["sum"] ?? ""}"),
              ],
              if (productList.isEmpty) ...[
                const SizedBox()
              ] else ...[
                Expanded(child: buildTotal(context, data)),
                const Spacer(),
                Expanded(flex: 2, child: buildCheckoutButton(context)),
              ]
            ],
          ),
        );
      },
    );
  }

  Row buildCartHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Cart",
          style: context.textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.lowValue),
              color: context.colors.error),
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: const Center(
                            child: Text("Clear the cart?"),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      databaseService.clearCart();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"))
                              ],
                            )
                          ],
                        ));
              },
              icon: const Icon(Icons.delete)),
        ),
      ],
    );
  }

  ListView buildCart(List<dynamic> productList) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (BuildContext context, int index) {
        var product = ProductModel.fromJson(productList[index]);
        return CartTile(product: product);
      },
    );
  }

  List<Widget> buildEmptyCart(BuildContext context) {
    return [
      const Spacer(
        flex: 8,
      ),
      Expanded(flex: 8, child: Image.asset("assets/shopping-cart.png")),
      Expanded(
        flex: 4,
        child: FittedBox(
          child: Text(
            "Empty Cart",
            style: context.textTheme.bodyText2,
          ),
        ),
      ),
      Expanded(
        flex: 8,
        child: FittedBox(
          alignment: Alignment.center,
          child: Text(
            "Your cart is still empty, browse the catalogue",
            style: context.textTheme.bodyText1!
                .copyWith(color: context.colors.onBackground),
          ),
        ),
      )
    ];
  }

  Row buildTotal(BuildContext context, Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total:",
          style: context.textTheme.bodyText1,
        ),
        RichText(
            text: TextSpan(
                style: context.textTheme.headline6!
                    .copyWith(color: context.colors.primary),
                children: [
              const TextSpan(text: "\$ "),
              TextSpan(
                  text: "${data["sum"] ?? ""}",
                  style: context.textTheme.headline6),
            ])),
      ],
    );
  }

  Row buildCheckoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: CustomElevatedButton(text: "Checkout", onPressed: () {})),
      ],
    );
  }
}
