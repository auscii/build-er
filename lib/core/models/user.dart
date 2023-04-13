import 'dart:math';
import 'package:client/core/utils/global.dart';
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
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? profilePhoto;
  String? description;
  String? password;
  Address? address;
  String? roles; // List<Roles> roles;
  User? firebaseUser;
  String? userCompanyName;
  String? userPermit;
  String? userLicense;
  String? userDTI;
  String? userSec;
  String? userValidID;
  String? isUserVerified;

  UserModel({
    this.name,
    this.email,
    this.password,
    this.phone,
    this.address,
    String? profileShot,
    String? uid,
    this.roles,
    String? userInfo,
    String? companyName,
    String? permit,
    String? license,
    String? dti,
    String? sec,
    String? validID,
    String? isUserVerified
  }) : firebaseUser = FirebaseAuth.instance.currentUser,
        uid = uid ?? FirebaseAuth.instance.currentUser?.uid,
        description = userInfo ??
          "Currently you have no description about you, add your description about you so that other people can know about you",
        profilePhoto = profileShot ??
          "https://avatars.dicebear.com/api/adventurer/$name\.svg",
        userCompanyName = companyName,
        userPermit = permit,
        userLicense = license,
        userDTI = dti,
        userSec = sec,
        userValidID = validID,
        isUserVerified = isUserVerified;

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
      name: customName ?? Var.e,
      email: Var.e,
      password: Var.e,
      phone: Var.e,
      address: Client.sample().address,
      roles: Var.e, // [Roles.error],
      companyName: Var.e,
      permit: Var.e,
      license: Var.e,
      dti: Var.e,
      sec: Var.e,
      validID: Var.e,
      isUserVerified: Var.e,
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
      license: data["license"],
      dti: data["dti"],
      sec: data["sec"],
      roles: data["roles"],
      validID: data["validID"],
      isUserVerified: data["isUserVerified"],
      uid: data['uid'],
      userInfo: data["description"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address?.toFirestore(),
      "profilePhoto": profilePhoto,
      "roles": roles,
      "companyName": userCompanyName,
      "permit": userPermit,
      "license": userLicense,
      "dti": userDTI,
      "sec": userSec,
      "validID": userValidID,
      "description": description,
      "isUserVerified": isUserVerified,
    };
  }

}
