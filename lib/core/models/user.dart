import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'client.dart';
import '../../core/models/address.dart';

enum Roles { user, client, admin, error }

extension RolesListTransform on List {
  List<String> toRolesString() {
    return map((role) => role.toString().split('.').last).toList();
  }
}

List<Roles> toRoles(List<String> data) {
  return data
      .map((role) => Roles.values.firstWhere(
            (element) => element.toString().split('.').last == role,
            orElse: () => Roles.error,
          ))
      .toList();
}

enum SignInMethods { google, github, email }

extension AuthMethods on SignInMethods {
  String toName() {
    return toString().split('.').last.toTitleCase();
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class UserModel {
  String name;
  String email;
  String phone;
  String profilePhoto;
  String description;
  String password;
  Address address;
  String roles; // List<Roles> roles;
  User? firebaseUser;
  String? uid;
  String? userCompanyName;
  String? userPermit;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    String? profileShot,
    String? uid,
    required this.roles,
    String? userInfo,
    String? companyName,
    String? permit,
  }) : firebaseUser = FirebaseAuth.instance.currentUser,
        uid = uid ?? FirebaseAuth.instance.currentUser?.uid,
        description = userInfo ??
          "Currently you have no description about you, add your description about you so that other people can know about you",
        profilePhoto = profileShot ??
          "https://avatars.dicebear.com/api/adventurer/$name\.svg",
        userCompanyName = companyName,
        userPermit = permit;

  createProfilePic() {
    String profileColor = Colors
        .primaries[Random().nextInt(Colors.primaries.length)]
        .toString()
        .substring(39, 45);
    profilePhoto =
        "https://ui-avatars.com/api/?name=\"$name\"&background=$profileColor&color=fff";
  }

  factory UserModel.clear({String? customName}) {
    return UserModel(
      name: customName ?? "name",
      email: "email",
      password: "password",
      phone: "phone",
      address: Client.sample().address,
      roles: "roles", // [Roles.error],
      companyName: "companyName",
      permit: "permit"
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data!["name"],
      email: data["email"],
      password: data["password"],
      phone: data["phone"],
      address: Address.fromFirestore(data["address"]),
      profileShot: data["profilePhoto"],
      companyName: data["companyName"],
      permit: data["permit"],
      roles: data["roles"],
      // roles: toRoles(
      //   List<String>.from(
      //     data["roles"],
      //   ),
      // ),
      uid: data['uid'],
      userInfo: data["description"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address.toFirestore(),
      "profilePhoto": profilePhoto,
      "roles": roles, //roles.toRolesString(),
      "companyName": userCompanyName,
      "permit": userPermit,
      "description": description,
      "uid": uid,
    };
  }

}
