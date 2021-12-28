import '../../../core/components/buttons/custom_elevated_button.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:coflow_app/core/extension/context_extension.dart';

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
            flex: 5,
            child: buildProductCard(context),
          ),
          Expanded(
            flex: 1,
            child: buildAddToCartButton(context),
          ),
        ],
      ),
    );
  }

  Center buildProductCard(BuildContext context) {
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
            context.normalValue,
          ),
        ),
        subtitle: Padding(
          padding: context.paddingLow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                productModel.name!,
                style: context.textTheme.headline4,
              ),
              Text(
                "${productModel.price} \$",
                style: context.textTheme.headline6!
                    .copyWith(color: context.colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAddToCartButton(BuildContext context) {
    return Padding(
      padding: context.paddingNormalHorizontal,
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: "Add to Cart",
              onPressed: () {
                databaseService.addToCart(productModel);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Added to cart"),
                ));
              },
            ),
            //     ElevatedButton(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(
            //         Icons.add_shopping_cart,
            //       ),
            //       Spacer(),
            //       Text("Add to Cart"),
            //       Spacer(),
            //     ],
            //   ),
            //   onPressed: () {
            //     databaseService.addToCart(productModel);
            //     // databaseService.addToCart(productModel.toJson());
            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //       content: Text("Added to cart"),
            //     ));
            //   },
            //   style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.all(14),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15))),
            // )
          )
        ],
      ),
    );
  }
}
