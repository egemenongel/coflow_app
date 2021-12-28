import '../../widgets/product_tile/product_tile.dart';

import '../../services/database_service.dart';

import '../../models/product_model.dart';
import 'package:flutter/material.dart';

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
        return Column(
          children: [
            if (productList.isEmpty)
              ...buildEmptyCart
            else ...[
              Expanded(
                flex: 9,
                child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var product = ProductModel.fromJson(productList[index]);
                    return ListTile(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Center(
                              child: Text("Remove this item from your cart?"),
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      contentPadding: const EdgeInsets.all(20),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
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
                            icon: const Icon(Icons.add,
                                size: 15, color: Color(0xffFE2C21)),
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
                            style: const TextStyle(color: Color(0xffFE2C21)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            Expanded(flex: 1, child: buildTotalInfo(context, data)),
          ],
        );
      },
    );
    // return StreamBuilder(
    //   stream: databaseService.cartReference.snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (!snapshot.hasData) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text("${snapshot.error}");
    //     }
    //     return Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Column(
    //         children: [
    //           const Expanded(
    //             flex: 3,
    //             child: FittedBox(
    //               child: Text("Your Cart"),
    //             ),
    //           ),
    //           Text(count.toString()),
    //           Expanded(flex: 40, child: buildCart(snapshot)),
    //           Expanded(
    //             flex: 3,
    //             child: snapshot.data.docs.length != 0
    //                 ? buildTotalInfo(context, snapshot)
    //                 : const SizedBox(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  Padding buildCart(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                    snapshot.data.data() as Map<String, dynamic>;
                List productList = data["productList"] ?? [];
                var product = ProductModel.fromJson(productList[index]);

                return ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
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
                        icon: const Icon(Icons.add,
                            size: 15, color: Color(0xffFE2C21)),
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
                        style: const TextStyle(color: Color(0xffFE2C21)),
                      ),
                    ],
                  ),
                );
                // return ProductTile(myProduct: myProducts);
              },
            ),
          )
        ],
      ),
    );
  }

  // buildProductTile(BuildContext context, dynamic myProduct) {
  //   Map<String, dynamic> data = myProduct.data() as Map<String, dynamic>;
  //   var product = ProductModel.fromJson(data);

  //   return ListTile(
  //     contentPadding: const EdgeInsets.symmetric(vertical: 20),
  //     leading: SizedBox(
  //       height: 50,
  //       width: 50,
  //       child: FittedBox(
  //         fit: BoxFit.fitWidth,
  //         child: ClipRRect(
  //             borderRadius: BorderRadius.circular(50),
  //             child: Image.network("${product.img}")),
  //       ),
  //     ),
  //     title: Text("${product.name}"),
  //     trailing: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         IconButton(
  //           icon: const Icon(
  //             Icons.remove,
  //             size: 15,
  //           ),
  //           splashRadius: 17,
  //           onPressed: () =>
  //               context.read<ProductController>().decrement(product),
  //         ),

  //         Consumer<ProductController>(builder: (_, _productController, ___) {
  //           return Text("${product.count}");
  //         }),
  //         // Consumer<ProductController>(
  //         //     builder: (_, __, ___) => Text("${__.count}")),
  //         IconButton(
  //           icon: const Icon(Icons.add, size: 15, color: Color(0xffFE2C21)),
  //           splashRadius: 17,
  //           onPressed: () =>
  //               context.read<ProductController>().increment(product),
  //         ),
  //         // Container(
  //         //   decoration: const BoxDecoration(
  //         //     shape: BoxShape.circle,
  //         //     color: Colors.red,
  //         //   ),
  //         //   child: IconButton(
  //         //     icon: const Icon(Icons.delete, size: 15, color: Colors.white),
  //         //     splashRadius: 30,
  //         //     onPressed: () => myProduct.reference.delete(),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //     subtitle: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "${product.code}",
  //         ),
  //         Text(
  //           "${product.price} \$",
  //           style: const TextStyle(color: Color(0xffFE2C21)),
  //         ),
  //         Text(
  //           "${product.count}",
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  List<Widget> get buildEmptyCart {
    return [
      const Spacer(
        flex: 2,
      ),
      Expanded(flex: 4, child: Image.asset("assets/shopping-cart.png")),
      const Expanded(
        flex: 1,
        child: FittedBox(
          child: Text("Empty Cart"),
        ),
      ),
      const Expanded(
        flex: 2,
        child: FittedBox(
          alignment: Alignment.center,
          child: Text(
            "Your cart is still empty, browse the catalogue",
            style: TextStyle(
              color: Colors.grey,
            ),
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
        const Text(
          "Total:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
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
            ))
      ],
    );
  }
}
