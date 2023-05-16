import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String id;
  String message;
  String receiverUserID;
  String createdAt;
  String createdBy;
  int status;

  Messages({
    required this.id,
    required this.message,
    required this.receiverUserID,
    required this.createdAt,
    required this.createdBy,
    required this.status
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "message": message,
      "receiverUserID": receiverUserID,
      "createdAt": createdAt,
      "createdBy": createdBy,
      "status": status
    };
  }

  factory Messages.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Messages(
      id: data['id'],
      message: data['message'],
      receiverUserID: data['receiverUserID'],
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      status: data['status'],
    );
  }
  
}