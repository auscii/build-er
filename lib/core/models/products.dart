import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;
  final String createdBy;
  final Timestamp? dateTimeCreated;

  Product({
    required this.id,
    String? image,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.createdBy,
    this.dateTimeCreated,
  }) : image = image ?? createProfilePic(name: title);

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Product(
      id: data!["id"],
      image: data["productImage"] ?? 
        createProfilePic(name: data["productName"]),
      title: data["productName"],
      description: data["productDescription"],
      price: data["productPrice"],
      category: data["productCategory"],
      createdBy: data["productCreatedBy"],
      dateTimeCreated: data["productDateTimeCreated"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "productImage": image,
      "productName": title,
      "productDescription": description,
      "productPrice": price,
      "productCategory": category,
      "productCreatedBy": createdBy,
      "productDateTimeCreated": dateTimeCreated,
    };
  }
}

String createProfilePic({required String name}) {
  String profileColor = Colors
      .primaries[Random().nextInt(Colors.primaries.length)]
      .toString()
      .substring(39, 42);
  return "https://avatars.dicebear.com/api/initials/$name";
}
