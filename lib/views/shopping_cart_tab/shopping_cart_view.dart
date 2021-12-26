import '../../widgets/product_tile/product_tile.dart';

import '../../controllers/product_controller.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import 'package:flutter/material.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({Key? key}) : super(key: key);

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView>
    with AutomaticKeepAliveClientMixin<ShoppingCartView> {
  final DatabaseService databaseService = DatabaseService();
  var count = 0;
  void inc() {
    setState(() {
      count++;
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: databaseService.userCartReference.get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Text(data["cart"][0]["productName"]);
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
          if (snapshot.data.docs.length != 0) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var myProducts = snapshot.data.docs[index];
                  return ProductTile(myProduct: myProducts);
                },
              ),
            )
          ] else
            ...buildEmptyCart
        ],
      ),
    );
  }

  buildProductTile(BuildContext context, dynamic myProduct) {
    Map<String, dynamic> data = myProduct.data() as Map<String, dynamic>;
    var productModel = ProductModel.fromJson(data);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network("${productModel.img}")),
        ),
      ),
      title: Text("${productModel.name}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove,
              size: 15,
            ),
            splashRadius: 17,
            onPressed: () =>
                context.read<ProductController>().decrement(productModel),
          ),

          Consumer<ProductController>(builder: (_, _productController, ___) {
            return Text("${productModel.count}");
          }),
          // Consumer<ProductController>(
          //     builder: (_, __, ___) => Text("${__.count}")),
          IconButton(
            icon: const Icon(Icons.add, size: 15, color: Color(0xffFE2C21)),
            splashRadius: 17,
            onPressed: () =>
                context.read<ProductController>().increment(productModel),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.red,
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.delete, size: 15, color: Colors.white),
          //     splashRadius: 30,
          //     onPressed: () => myProduct.reference.delete(),
          //   ),
          // ),
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${productModel.code}",
          ),
          Text(
            "${productModel.price} \$",
            style: const TextStyle(color: Color(0xffFE2C21)),
          ),
          Text(
            "${productModel.count}",
          ),
        ],
      ),
    );
  }

  buildDialog(BuildContext context, AsyncSnapshot snapshot) {
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
                  for (var product in snapshot.data.docs) {
                    product.reference.delete();
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

  Row buildTotalInfo(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
                        builder: (context) => buildDialog(context, snapshot));
                  },
                  icon: const Icon(Icons.delete)),
            ))
      ],
    );
  }
}
