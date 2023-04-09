import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'user.dart';
import 'address.dart';

class Contractor {
  static const role = "Contractor";
  String name, description, image, userUid;
  Address address;

  Contractor({
    required this.name,
    required this.address,
    required this.description,
    String? image,
    required this.userUid,
  }) : image = image ?? createProfilePic(name: name);

  factory Contractor.sample({String? name, Address? address, String? description}) {
    return Contractor(
      name: name ?? "Contractor Name ⚠️",
      address: address ??
          Address(name: "address", position: LatLng(-0.303099, 36.080025)),
      description: "description",
      userUid: 'sjdfhjsdhfhsdfhsdjhflsdhfjl',
    );
  }

  factory Contractor.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Contractor(
      name: data!["name"],
      description: data['description'],
      image: data['image'],
      address: Address.fromFirestore(data['address']),
      userUid: data['userUid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "description": description,
      "image": image,
      "address": address.toFirestore(),
      "userUid": userUid,
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

class ServiceRequest {
  String userId;
  String ContractorId;
  bool completed;

  ServiceRequest(
      {required this.userId, required this.completed, required this.ContractorId});

  factory ServiceRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ServiceRequest(
      userId: data!['user'],
      ContractorId: data['ContractorId'],
      completed: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'user': userId, 'ContractorId': ContractorId, 'status': completed};
  }
}

UserModel createUserModel(Map<String, dynamic> data) {
  return UserModel(
    name: data["name"],
    email: data["email"],
    password: data["password"],
    phone: data["phone"],
    address: data["address"],
    profileShot: data["profilePhoto"],
    roles: data["roles"],
    uid: data['uid'],
    userInfo: data["description"],
  );
}
