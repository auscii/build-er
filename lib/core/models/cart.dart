import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String docID;
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final double quantity;
  final String category;
  final String createdBy;
  final String createdAt;
  final String userAddedBy;

  Cart({
    required this.docID,
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    required this.userAddedBy,
  });

  factory Cart.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Cart(
      docID: data!["docID"],
      id: data["id"],
      image: data["productImage"],
      title: data["productName"],
      description: data["productDescription"],
      price: data["productPrice"],
      quantity: data["quantity"],
      category: data["productCategory"],
      createdBy: data["productCreatedBy"],
      createdAt: data["createdAt"],
      userAddedBy: data["userAddedBy"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "docID": docID,
      "id": id,
      "productImage": image,
      "productName": title,
      "productDescription": description,
      "productPrice": price,
      "quantity": quantity,
      "productCategory": category,
      "productCreatedBy": createdBy,
      "createdAt": createdAt,
      "userAddedBy": userAddedBy,
    };
  }
}