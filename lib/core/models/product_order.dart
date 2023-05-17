import 'package:client/core/models/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductOrder {
  final String transactionNumber;
  final String orderStatus;
  // final Product products;
  final double grandTotal;
  final String customerName;
  final String transactionDateTimeCreated;
  final String userAddedBy;
  final int status;

  ProductOrder({
    required this.transactionNumber,
    required this.orderStatus,
    // required this.products,
    required this.grandTotal,
    required this.customerName,
    required this.transactionDateTimeCreated,
    required this.userAddedBy,
    required this.status
  });

  factory ProductOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ProductOrder(
      transactionNumber: data!["transactionNumber"],
      orderStatus: data["orderStatus"],
      // products: Product.fromFirestore(data["products"], null),
      grandTotal: data["grandTotal"],
      customerName: data["customerName"],
      transactionDateTimeCreated: data["transactionDateTimeCreated"],
      userAddedBy: data["userAddedBy"],
      status: data["status"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "transactionNumber": transactionNumber,
      "orderStatus": orderStatus,
      // "products": products.toFirestore(),
      "grandTotal": grandTotal,
      "customerName": customerName,
      "transactionDateTimeCreated": transactionDateTimeCreated,
      "userAddedBy": userAddedBy,
      "status": status
    };
  }
  
}