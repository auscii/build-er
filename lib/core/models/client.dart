import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// 🏘️ Local imports
import 'user.dart';

class Client {
  String name, description, image, userUid;
  Address address;

  Client({
    required this.name,
    required this.address,
    required this.description,
    String? image,
    required this.userUid,
  }) : image = image ?? createProfilePic(name: name);

  factory Client.sample({String? name, Address? address, String? description}) {
    return Client(
      name: name ?? "Client Name ⚠️",
      address: address ??
          Address(name: "address", position: LatLng(-0.303099, 36.080025)),
      description: "description",
      userUid: 'sjdfhjsdhfhsdfhsdjhflsdhfjl',
    );
  }

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Client(
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

class Address {
  String name;
  LatLng position;

  Address({
    required this.name,
    required this.position,
  });

  Map<String, dynamic> toFirestore() {
    GeoPoint pos = GeoPoint(position.latitude, position.longitude);
    return {"name": name, "position": pos};
  }

  factory Address.fromFirestore(Map<String, dynamic> data) {
    GeoPoint pos = data['position'];
    return Address(
        name: data['name'], position: LatLng(pos.latitude, pos.longitude));
  }
}

class ServiceRequest {
  String userId;
  String clientId;
  bool completed;

  ServiceRequest(
      {required this.userId, required this.completed, required this.clientId});

  factory ServiceRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ServiceRequest(
      userId: data!['user'],
      clientId: data['clientId'],
      completed: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'user': userId, 'clientId': clientId, 'status': completed};
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
    roles: toRoles(
      List<String>.from(
        data["roles"],
      ),
    ),
    uid: data['uid'],
    userInfo: data["description"],
  );
}
