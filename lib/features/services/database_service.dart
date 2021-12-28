import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
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
    return await usersReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": email,
    });
  }

  Future addToCart(ProductModel product) async {
    userCartReference.update(
      {
        "productList": FieldValue.arrayUnion([
          product.toJson(),
        ]),
      },
    );
  }

  Future increment(ProductModel product) async {
    Map<String, dynamic> productJson = product.toJson();
    DocumentSnapshot list = await userCartReference.get();
    List arr = list.get("productList");

    for (var item in arr) {
      if (arr.contains(item)) {
        if (item["productCode"] == productJson["productCode"]) {
          var count = item["productCount"];
          count++;
          item["productCount"] = count;
        }
      }
    }

    await userCartReference.set({"productList": arr});
  }

  Future decrement(ProductModel product) async {
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

  Future removeProduct(ProductModel product) async {
    userCartReference.set({
      "productList": FieldValue.arrayRemove([product.toJson()]),
    }, SetOptions(merge: true));
  }

  Future clearCart() async {
    userCartReference.update({"productList": FieldValue.delete()});
  }
}
