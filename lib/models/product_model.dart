import 'dart:convert';

ProductModel productModelfromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? id;
  String? code;
  String? name;
  String? img;
  int? price;
  int count = 0;

  ProductModel({
    this.id,
    this.code,
    this.name,
    this.price,
    this.img,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["productName"],
        price: json["productPrice"],
        img: json["productImg"],
        code: json["productCode"],
        // productId: json["productId"],
      );
  Map<String, dynamic> toJson() => {
        "productName": name,
        "productPrice": price,
        "productImg": img,
        "productCode": code,
      };
}
