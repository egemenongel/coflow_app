import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;

  final _instance = FirebaseFirestore.instance;
  DatabaseService({this.uid}) {
    uid = uid;
  }
  CollectionReference get productsReference => _instance.collection("products");
  CollectionReference get cartReference => _instance.collection("cart");
  CollectionReference get usersReference => _instance.collection("users");
  DocumentReference get userCartReference => usersReference.doc(uid);
  Future updateUserData(
    String email,
  ) async {
    return await usersReference.doc(uid).set({
      "email": email,
    });
  }

  addToCart(Object product) {
    cartReference.add(product);
  }
}
