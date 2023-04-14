import 'dart:async';
import 'package:client/core/models/products.dart';
import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/modal.dart';
import 'package:client/core/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/models/address.dart';
import '../models/user.dart';
import '../models/client.dart';

class AppData extends ChangeNotifier {
  late StreamSubscription<QuerySnapshot<ClientRequests>> clientRequestListener;
  late StreamSubscription<QuerySnapshot<AdminRequests>> adminRequestListener;
  late StreamSubscription<QuerySnapshot<ServiceRequest>> serviceListener;

  String _currentRoute = Var.home;

  String get currentRoute {
    return _currentRoute[0].toUpperCase() + _currentRoute.substring(1);
  }

  Future<void> changeRoute(route) async {
    _currentRoute = route;
    notifyListeners();
  }

  AppData() {
    getClientRequest();
    getAdminRequest();
    getServiceRequest();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (FirebaseAuth.instance.currentUser == null && event == null) {
        clientRequestListener.cancel();
        adminRequestListener.cancel();
        serviceListener.cancel();
      }
      if (FirebaseAuth.instance.currentUser != null && event != null) {
        clientRequestListener.resume();
        adminRequestListener.resume();
        serviceListener.resume();
      }
    });
  }

  List<Client> clients = [];
  List<Product> products = [];

  late List<ClientRequests> _clientRequest = [];
  late List<AdminRequests> _adminRequest = [];
  late List<ServiceRequest> _serviceRequest = [];

  List<ClientRequests> get clientRequest => _clientRequest;

  List<AdminRequests> get adminRequest => _adminRequest;

  List<ServiceRequest> get serviceRequestN =>
      _serviceRequest.where((req) => req.completed == false).toList();

  List<ServiceRequest> get serviceRequestC =>
      _serviceRequest.where((req) => req.completed == true).toList();

  Future<void> createServiceRequest(ServiceRequest request) async {
    return await FirebaseFirestore.instance
        .collection("serviceRequest")
        .doc(request.clientId)
        .collection("Requests")
        .doc(request.userId)
        .withConverter(
          fromFirestore: ServiceRequest.fromFirestore,
          toFirestore: (ServiceRequest userModel, _) => userModel.toFirestore(),
        )
        .set(request);
  }

  getServiceRequest() {
    serviceListener = FirebaseFirestore.instance
        .collection("serviceRequest")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("Requests")
        .withConverter(
          fromFirestore: ServiceRequest.fromFirestore,
          toFirestore: (ServiceRequest userModel, _) => userModel.toFirestore(),
        )
        .snapshots()
        .listen((val) {
      _serviceRequest = val.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
  }

  Future<void> createProduct({required Product product}) async {
    return await FirebaseFirestore.instance
      .collection(Var.productS)
      .doc(product.id.toString())
      .withConverter(
          fromFirestore: Product.fromFirestore,
          toFirestore: (Product value, _) => value.toFirestore())
      .set(product)
      .then((value) {
        Toast.show(Var.productSuccess);
      });
  }

  static void getProductLists() async {
    await FirebaseFirestore.instance
      .collection(Var.productS)
      .withConverter(
        fromFirestore: Product.fromFirestore,
        toFirestore: (Product values, _) => values.toFirestore())
      .get()
      .then((res) {
        res.docs.forEach((val) {
          var products = val.data();
          Var.productLists.addAll({products});
        });
        AppData().notifyListeners();
      });
  }

  static void getUserLists() async {
    await FirebaseFirestore.instance
      .collection(Var.users)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel values, _) => values.toFirestore())
      .get()
      .then((res) {
        res.docs.forEach((val) {
          var users = val.data();
          // print("getUserLists user roles ->${users.roles}");
          // print("getUserLists user name ->${users.name}");
          Var.usersLists.addAll({users});
        });
        AppData().notifyListeners();
      });
  }

  static void getContractorUser() async {
    await FirebaseFirestore.instance
      .collection(Var.users)
      .where(Var.roles, isEqualTo: Var.contractor)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel values, _) => values.toFirestore())
      .get()
      .then((res) {
        res.docs.forEach((val) {
          var users = val.data();
          Var.filteredContractorUsers.addAll({users});
        });
        AppData().notifyListeners();
      });
  }

  static void getClientUser() async {
    await FirebaseFirestore.instance
      .collection(Var.users)
      .where(Var.roles, isEqualTo: Var.client)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel values, _) => values.toFirestore())
      .get()
      .then((res) {
        res.docs.forEach((val) {
          var users = val.data();
          Var.filteredClientUsers.addAll({users});
        });
        AppData().notifyListeners();
      });
  }

  Future<void> createClient({required Client client}) async {
    return await FirebaseFirestore.instance
      .collection(Var.clientS)
      .doc(client.userUid)
      .withConverter(
          fromFirestore: Client.fromFirestore,
          toFirestore: (Client userModel, _) => userModel.toFirestore())
      .set(client);
  }

  Future<List<Client>> getClientsList() async {
    final res = await FirebaseFirestore.instance
        .collection(Var.clientS)
        .withConverter(
            fromFirestore: Client.fromFirestore,
            toFirestore: (Client userModel, _) => userModel.toFirestore())
        .get()
        .then((res) {
      clients = res.docs.toList().cast();
      notifyListeners();
    });

    return res.docs.toList().cast() ?? [Client.sample()];
  }

  Future<Client> getClient({required String userUid}) async {
    final res = await FirebaseFirestore.instance
        .collection(Var.clientS)
        .doc(userUid)
        .withConverter(
            fromFirestore: Client.fromFirestore,
            toFirestore: (Client userModel, _) => userModel.toFirestore())
        .get()
        .onError((error, stackTrace) => Future.error("Unable to Get Client"));

    return res.data() ?? Client.sample();
  }

  Future<void> createAdminRequest({required AdminRequests payload}) async {
    return await FirebaseFirestore.instance
        .collection("adminRequests")
        .withConverter(
          fromFirestore: AdminRequests.fromFirestore,
          toFirestore: (AdminRequests req, _) => req.toFirestore(),
        )
        .doc(payload.userId)
        .set(payload);
  }

  Future<void> createClientRequest({required ClientRequests payload}) async {
    return await FirebaseFirestore.instance
        .collection("clientRequests")
        .withConverter(
          fromFirestore: ClientRequests.fromFirestore,
          toFirestore: (ClientRequests req, _) => req.toFirestore(),
        )
        .doc(payload.userId)
        .set(payload);
  }

  void getClientRequest() {
    clientRequestListener = FirebaseFirestore.instance
        .collection("clientRequests")
        .withConverter(
          fromFirestore: ClientRequests.fromFirestore,
          toFirestore: (ClientRequests userModel, _) => userModel.toFirestore(),
        )
        .snapshots()
        .listen((val) {
      _clientRequest = val.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
  }

  void getAdminRequest() {
    adminRequestListener = FirebaseFirestore.instance
        .collection("adminRequests")
        .withConverter(
            fromFirestore: AdminRequests.fromFirestore,
            toFirestore: (AdminRequests userModel, _) =>
                userModel.toFirestore())
        .snapshots()
        .listen((val) {
      _adminRequest = val.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
  }

  Future<void> updateUserDetails({required String userId}) async {
    final instance = FirebaseFirestore.instance
        .collection(Var.users)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel userModel, _) 
            => userModel.toFirestore())
        .doc(userId);
    instance.get().then((value) {
      instance.update({
        Var.isUserVerified: Var.adminApprovedUserVerification
      });
      UserProvider.clearUserLists();
    }).then((_) => {
      Toast.show(Var.userIsNowUpdated)
    });
  }

  static checkUserIfVerified() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? Var.e;
    await FirebaseFirestore.instance
      .collection(Var.users)
      .where(Var.uid, isEqualTo: uid)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel values, _) => values.toFirestore())
      .get()
      .then((res) {
        res.docs.forEach((val) {
          var user = val.data();
          if (user.isUserVerified == Var.userPendingForVerification) {
            Var.userIsVerified = true;
            AppData().notifyListeners();
          }
        });
      });
    return;
  }

  static getUserResultIfVerified(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (Var.userIsVerified) {
        Modal.modalInfo(context, Var.notVerifiedUseMsg);
      }
    });
  }

}

class AdminRequests {
  String userId, description;
  UserModel? user;

  AdminRequests({
    required this.userId,
    required this.description,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel userModel, _) => userModel.toFirestore(),
        )
        .get()
        .then((value) {
      user = value.data();
    }).onError((error, stackTrace) {
      user = UserModel.clear(customName: 'Unable to Parse data');
    });
  }

  factory AdminRequests.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AdminRequests(
      userId: data!['userId'],
      description: data['description'],
    );
  }

  toFirestore() {
    return {
      "userId": userId,
      "description": description,
    };
  }
}

class ClientRequests {
  String userId;
  Client client;

  ClientRequests({required this.client, required this.userId});

  factory ClientRequests.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClientRequests(
      userId: data!['userId'],
      client: mapToClient(data['client']),
    );
  }

  toFirestore() {
    return {
      "userId": userId,
      Var.clientS: client.toFirestore(),
    };
  }
}

Client mapToClient(Map<String, dynamic> data) {
  return Client(
    name: data["name"],
    description: data['description'],
    image: data['image'],
    address: Address.fromFirestore(data['address']),
    userUid: data['userUid'],
  );
}
