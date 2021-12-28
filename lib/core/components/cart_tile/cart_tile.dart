import '../../../features/models/product_model.dart';
import '../../../features/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../../core/extension/context_extension.dart';

class CartTile extends StatelessWidget {
  CartTile({
    Key? key,
    required this.product,
  }) : super(key: key);
  final DatabaseService databaseService = DatabaseService();
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () => showDialog(
        context: context,
        builder: (context) => buildRemoveItemDialog(context),
      ),
      contentPadding: context.paddingNormalVertical,
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
            icon: Icon(Icons.add, size: 15, color: context.colors.primary),
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
  }

  SimpleDialog buildRemoveItemDialog(BuildContext context) {
    return SimpleDialog(
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
    );
  }
}
