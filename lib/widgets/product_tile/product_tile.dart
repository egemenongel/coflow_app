import 'package:coflow_app/services/database_service.dart';

import '../../models/product_model.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  ProductTile({Key? key, required this.myProduct}) : super(key: key);
  final dynamic myProduct;
  final databaseService = DatabaseService();
  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile>
    with AutomaticKeepAliveClientMixin<ProductTile> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Map<String, dynamic> data = widget.myProduct.data() as Map<String, dynamic>;
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
          // IconButton(
          //   icon: const Icon(
          //     Icons.remove,
          //     size: 15,
          //   ),
          //   splashRadius: 17,
          //   onPressed: () =>
          //       context.read<ProductController>().decrement(productModel),
          // ),
          Text("${productModel.count}"),
          // Consumer<ProductController>(
          //     builder: (_, __, ___) => Text("${__.count}")),
          IconButton(
            icon: const Icon(Icons.add, size: 15, color: Color(0xffFE2C21)),
            splashRadius: 17,
            onPressed: () => widget.databaseService.increment(productModel),
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
}
