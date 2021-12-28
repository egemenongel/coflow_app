import '../../services/database_service.dart';

import '../../models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:coflow_app/core/extension/context_extension.dart';

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
              else
                ...buildCart(context, productList),
              productList.isEmpty
                  ? const SizedBox()
                  : Expanded(flex: 2, child: buildTotalInfo(context, data)),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildCart(BuildContext context, List productList) {
    return [
      Expanded(
        flex: 1,
        child: FittedBox(
          child: Text(
            "Cart",
            style: context.textTheme.headline6,
          ),
        ),
      ),
      const Spacer(
        flex: 1,
      ),
      Expanded(
        flex: 18,
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            var product = ProductModel.fromJson(productList[index]);
            return ListTile(
              contentPadding: context.paddingNormalVertical,
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Center(
                      child: Text("Remove this item from your cart?"),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                databaseService.removeProduct(product);
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
                  ),
                );
              },
              leading: SizedBox(
                height: 50,
                width: 50,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.highValue),
                      child: Image.network("${product.img}")),
                ),
              ),
              title: Text("${product.name}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove,
                      size: 15,
                    ),
                    splashRadius: 17,
                    onPressed: () {
                      databaseService.decrement(product);
                    },
                  ),
                  Text("${product.count}"),
                  IconButton(
                    icon: Icon(Icons.add,
                        size: 15, color: context.colors.primary),
                    splashRadius: 17,
                    onPressed: () {
                      databaseService.increment(product);
                    },
                  ),
                ],
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product.code}",
                  ),
                  Text(
                    "${product.price} \$",
                    style: context.textTheme.bodyText1!
                        .copyWith(color: context.colors.primary),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }

  buildDialog(BuildContext context, List productList) {
    return SimpleDialog(
      title: const Center(
        child: Text("Clear the cart?"),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  for (var product in productList) {
                    product.delete();
                  }
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

  Row buildTotalInfo(BuildContext context, Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(
          flex: 4,
        ),
        const Expanded(
          flex: 1,
          child: Text(
            "Total:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 1,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.lowValue),
                  color: context.colors.error),
              child: FittedBox(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
              )),
        )
      ],
    );
  }
}
