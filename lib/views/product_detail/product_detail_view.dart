import '../../models/product_model.dart';
import '../../services/database_service.dart';
import 'package:flutter/material.dart';

class ProductDetailView extends StatelessWidget {
  ProductDetailView({Key? key, required this.productModel}) : super(key: key);
  final ProductModel productModel;
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: buildProductCard(),
          ),
          Expanded(
            flex: 1,
            child: buildAddToCartButton(context),
          ),
        ],
      ),
    );
  }

  Center buildProductCard() {
    return Center(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        title: ClipRRect(
          child: Image.network(
            "${productModel.img}",
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(productModel.name!),
              Text(
                "${productModel.price} \$",
                style: const TextStyle(color: Color(0xffFE2C21)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAddToCartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_shopping_cart,
                ),
                Spacer(),
                Text("Add to Cart"),
                Spacer(),
              ],
            ),
            onPressed: () {
              databaseService.addToCart(productModel);
              // databaseService.addToCart(productModel.toJson());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Added to cart"),
              ));
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ))
        ],
      ),
    );
  }
}
