import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../product_detail/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:coflow_app/core/extension/context_extension.dart';

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
                padding: EdgeInsets.all(context.lowValue),
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
        color: context.colors.background,
        elevation: 0,
        child: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: context.paddingLowHorizontal,
                    child: ClipRRect(
                      child: Image.network(
                        "${productModel.img}",
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.circular(
                        context.normalValue,
                      ),
                    ),
                  ),
                )
              ],
            )),
            Text(productModel.name!),
            Text(
              "${productModel.price!} \$",
              style: context.textTheme.bodyText1!
                  .copyWith(color: context.colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
