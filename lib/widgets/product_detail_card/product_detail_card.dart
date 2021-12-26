// import 'package:flutter/material.dart';
// import '../../models/product_model.dart';

// class ProductDetailCard extends StatelessWidget {
//   const ProductDetailCard({Key? key, required this.productModel})
//       : super(key: key);
//   final ProductModel productModel;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ListTile(
//         contentPadding: EdgeInsets.zero,
//         minVerticalPadding: 0,
//         title: ClipRRect(
//           child: Image.network(
//             "${productModel.img}",
//             fit: BoxFit.fitWidth,
//           ),
//           borderRadius: BorderRadius.circular(
//             20,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(productModel.name!),
//               Text(
//                 "${productModel.price} \$",
//                 style: const TextStyle(color: Color(0xffFE2C21)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
