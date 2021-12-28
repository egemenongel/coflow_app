import 'package:flutter/material.dart';

import '../../../core/extension/context_extension.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../product_detail/product_detail_view.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final auth = AuthService();
  final databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: buildHeaderText(context)),
              Expanded(
                  flex: 18,
                  child: GridView.builder(
                    padding: EdgeInsets.all(context.lowValue),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                  )),
            ],
          );
        },
      ),
    );
  }

  Padding buildHeaderText(BuildContext context) {
    return Padding(
      padding: context.paddingMediumHorizontal,
      child: Text("Most Popular", style: context.textTheme.headline4!),
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
              style: context.textTheme.bodyText2!
                  .copyWith(color: context.colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
