import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coflow_app/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  String? uid;

  final _instance = FirebaseFirestore.instance;
  DatabaseService({this.uid}) {
    uid = uid;
  }
  CollectionReference get productsReference => _instance.collection("products");
  CollectionReference get cartReference => _instance.collection("cart");
  CollectionReference get usersReference => _instance.collection("users");
  DocumentReference get userCartReference => _instance
      .collection("userCarts")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Future updateUserData(
    String? email,
  ) async {
    userCartReference.set(
      {
        "productList": [],
      },
    );
    return await usersReference.doc(uid).set({
      "email": email,
    });
  }

  // addToCart(Object product) {
  //   cartReference.add(product);
  // }

  increment(ProductModel product) async {
    // If the product exists => count++ else add product
    Map<String, dynamic> productJson = product.toJson();
    DocumentSnapshot list = await userCartReference.get();
    List arr = list.get("productList");
    // if (arr[0]["productCode"] == product.toJson()["productCode"]) {
    //   print("a");
    // } else {
    //   print("b");
    // }

    // productJson["count"] = 2;
    // List<Map<String, dynamic>> a = list.get("productList");

    for (var item in arr) {
      if (arr.contains(item)) {
        if (item["productCode"] == productJson["productCode"]) {
          var count = item["productCount"];
          count++;
          item["productCount"] = count;
        }
      }
    }

    // if (arr.contains(productJson)) {
    //   print("a");
    // }

    // arr[0]["count"] = 1;

    await userCartReference.set({"productList": arr});
  }

  decrement(ProductModel product) async {
    Map<String, dynamic> productJson = product.toJson();
    DocumentSnapshot list = await userCartReference.get();
    List arr = list.get("productList");

    for (var item in arr) {
      if (arr.contains(item)) {
        if (item["productCode"] == productJson["productCode"]) {
          var count = item["productCount"];
          count != 1 ? count-- : null;

          item["productCount"] = count;
        }
      }
    }

    await userCartReference.set({"productList": arr});
  }

  addToCart(ProductModel product) async {
    userCartReference.update(
      {
        "productList": FieldValue.arrayUnion([
          product.toJson(),
        ]),
      },
    );
  }

  removeProduct(ProductModel product) async {
    userCartReference.set({
      "productList": FieldValue.arrayRemove([product.toJson()]),
    }, SetOptions(merge: true));
  }

  clearCart() async {
    userCartReference.update({"productList": FieldValue.delete()});
  }
  // addToUserCart(ProductModel product) async {
  //   userCartReference.collection("cart").add(product.toJson());

  //   // List list = await userCartReference.get(FieldPath());
  //   // userCartReference.set({
  //   //   "productList": [
  //   //     product.toJson(),
  //   //     product.toJson(),
  //   //   ]
  //   // });
  // }
}
