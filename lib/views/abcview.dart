import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class AbcView extends StatelessWidget {
  AbcView({Key? key}) : super(key: key);
  final CollectionReference ref = FirebaseFirestore.instance.collection("cart");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: ref.doc("3x12YPyoip2fpwtcB02s").get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            var product = ProductModel.fromJson(data);
            if (!snapshot.hasData) {
              return const Text("no");
            } else if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            return Text(product.name!);
          },
        ),
      ),
    );
  }
}
