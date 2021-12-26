import '../models/product_model.dart';
import 'package:flutter/cupertino.dart';

class ProductController extends ChangeNotifier {
  int count = 0;

  void increment(ProductModel productModel) {
    productModel.count++;
    notifyListeners();
  }

  void decrement(ProductModel productModel) {
    productModel.count != 0 ? productModel.count-- : null;
    notifyListeners();
  }
}
