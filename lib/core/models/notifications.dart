import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String id;
  String actionMessage;
  String type;
  String toUser;
  String createdAt;
  String createdBy;
  int status;

  Notifications({
    required this.id,
    required this.actionMessage,
    required this.type,
    required this.toUser,
    required this.createdAt,
    required this.createdBy,
    required this.status
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "actionMessage": actionMessage,
      "type": type,
      "toUser": toUser,
      "createdAt": createdAt,
      "createdBy": createdBy,
      "status": status
    };
  }

  factory Notifications.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Notifications(
      id: data['id'],
      actionMessage: data['actionMessage'],
      type: data['type'],
      toUser: data['toUser'],
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      status: data['status'],
    );
  }
  
}