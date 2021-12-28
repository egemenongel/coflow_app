import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../product_detail/product_detail_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final auth = AuthService();
  final databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: databaseService.productsReference.snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                Text("${snapshot.error}");
              }
              return Expanded(
                  child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = snapshot.data.docs[index];
                  Map<String, dynamic> data =
                      product.data() as Map<String, dynamic>;
                  var productModel = ProductModel.fromJson(data);
                  return buildProductCard(context, productModel);
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  InkWell buildProductCard(BuildContext context, ProductModel productModel) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailView(
                      productModel: productModel,
                    )));
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      child: Image.network(
                        "${productModel.img}",
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                )
              ],
            )),
            Text(productModel.name!),
            Text(
              "${productModel.price!} \$",
              style: const TextStyle(color: Color(0xffFE2C21)),
            ),
          ],
        ),
      ),
    );
  }
}
