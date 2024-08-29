// To parse this JSON data, do
//
//     final qrData = qrDataFromJson(jsonString);

import 'dart:convert';

QrData qrDataFromJson(String str) => QrData.fromJson(json.decode(str));

String qrDataToJson(QrData data) => json.encode(data.toJson());

class QrData {
  QrData({
    this.productName,
    this.metaDescription,
    this.description,
    this.variationName,
    this.sellPrice,
    this.purchasePrice,
    this.sku,
    this.quantity,
    this.imageProfile,
  });

  String? productName;
  String? metaDescription;
  String? description;
  String? variationName;
  String? sellPrice;
  String? purchasePrice;
  String? sku;
  String? quantity;
  String? imageProfile;

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    productName: json["product_name"] == null ? null : json["product_name"],
    metaDescription: json["meta_description"] == null ? null : json["meta_description"],
    description: json["description"] == null ? null : json["description"],
    variationName: json["variation_name"] == null ? null : json["variation_name"],
    sellPrice: json["sell_price"] == null ? null : json["sell_price"],
    purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
    sku: json["sku"] == null ? null : json["sku"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    imageProfile: json["imageProfile"] == null ? null : json["imageProfile"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName == null ? null : productName,
    "meta_description": metaDescription == null ? null : metaDescription,
    "description": description == null ? null : description,
    "variation_name": variationName == null ? null : variationName,
    "sell_price": sellPrice == null ? null : sellPrice,
    "purchase_price": purchasePrice == null ? null : purchasePrice,
    "sku": sku == null ? null : sku,
    "quantity": quantity == null ? null : quantity,
    "imageProfile": imageProfile == null ? null : imageProfile,
  };
}
