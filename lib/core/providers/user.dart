import 'package:client/core/providers/appdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/address.dart';
import '../models/client.dart';
import '../models/user.dart';
import '../../screens/auth/onboarding.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../utils/global.dart';
import '../utils/loader.dart';
import '../utils/toast.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _user = UserModel.clear();

  init() {
    if (FirebaseAuth.instance.currentUser != null) {
      // AppData.initApplication();
      var userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
        .collection(Var.users)
        .doc(userId)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel userModel, _) => userModel.toFirestore())
        .get()
        .then((snap) {
        _user = snap.data()!;
        notifyListeners();
      });
    } else {
      _user = UserModel.clear();
      notifyListeners();
    }

    // if (_user == UserModel.clear()) {
    //   GlobalNavigator.router.currentState!
    //       .pushReplacementNamed(GlobalRoutes.auth);
    // }
    // Loader.stop();
  }

  UserProvider() {
    init();
  }

  UserModel get user => _user;

  void updateUser({
    required BuildContext context,
    required String name,
    required Address? address,
    required String phone,
    required String description,
    required String? email,
  }) {
    if (_user != UserModel.clear() &&
        FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection(Var.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "name": name.isEmpty ? _user.name : name,
        "email": email ?? _user.email ?? Var.na, //email?.isEmpty ? _user.email : email,
        "phone": phone.isEmpty ? _user.phone : phone,
        "address": address != null
            ? address.toFirestore()
            : _user.address?.toFirestore(),
        "description": description.isEmpty ? _user.description : description,
      }).then((value) {
        User? currentDetails = FirebaseAuth.instance.currentUser;
        currentDetails?.updateDisplayName(name.isEmpty ? _user.name : name);
        currentDetails?.updateEmail(email ?? _user.email ?? Var.na); //(email.isEmpty ? _user.email : email);
      }).then((value) {
        FirebaseFirestore.instance
            .collection(Var.users)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .withConverter(
                fromFirestore: UserModel.fromFirestore,
                toFirestore: (UserModel userModel, _) =>
                    userModel.toFirestore())
            .get()
            .then((snap) {
          _user = snap.data()!;
          notifyListeners();
        }).then((value) => Navigator.of(context, rootNavigator: true).pop());
      });
    }
  }

  void _resolveAuthError(
      {required FirebaseAuthException error,
      required BuildContext context,
      required SignInMethods signInMethods}) {
    Loader.stop();
    ScaffoldMessenger.of(context).showSnackBar(
      alertSnackBar(
        message:
          "${signInMethods.toName()} Authentication Failed 😢 \n \n ${error.message}",
      ),
    );
  }

  void createUser({
    required BuildContext context,
    required UserModel payload,
    SignInMethods signInMethods = SignInMethods.email,
  }) {
    if (signInMethods == SignInMethods.email) {
      FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: payload.email ?? "",
            password: payload.password ?? ""
        ).then((credentials) async {
          credentials.user!.updateDisplayName(payload.name);
          credentials.user!.updatePhotoURL(payload.profilePhoto);
          storeNewUser(
            credentials.user!.uid,
            payload.email,
            payload.password,
            payload.name,
            payload.phone,
            payload.address,
            payload.roles,
            payload.userCompanyName,
            payload.userPermit,
            payload.userLicense,
            payload.userDTI,
            payload.userSec,
            payload.userValidID,
            payload.isUserVerified
          );
        })
        .then((_) => init())
        .onError((FirebaseAuthException error, stackTrace) {
          _resolveAuthError(
            error: error,
            context: context,
            signInMethods: SignInMethods.email,
          );
          return;
        });
        Loader.stop();
    } else {
      FirebaseFirestore.instance
          .collection(Var.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel userModel, _) => userModel.toFirestore())
          .set(payload);
      Loader.stop();
    }
  }

  void socialAuth(
      {required SignInMethods auth,
      required UserCredential credentials,
      required BuildContext context}) {
    FirebaseFirestore.instance
        .collection(Var.users)
        .doc(credentials.user!.uid)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel userModel, _) => userModel.toFirestore())
        .get()
        .then((doc) {
          if (doc.exists == false) {
            if (credentials.user!.photoURL == null) {
              credentials.user!.updatePhotoURL(
                UserModel.clear(customName: credentials.user!.displayName!)
                    .profilePhoto);
            }
            createUser(
              context: context,
              payload: UserModel(
                name: credentials.user!.displayName!,
                email: credentials.user!.email!,
                uid: credentials.user!.uid,
                password: credentials.user!.refreshToken ?? "No Auth Token",
                phone: "No Phone Number",
                address: Client.sample().address,
                profileShot: credentials.user!.photoURL,
                roles: "",
              ),
              signInMethods: auth,
            );
          }
        })
        .then((_) => init())
        .then(
          (_) => GlobalNavigator.router.currentState!
              .pushReplacementNamed(GlobalRoutes.switchRoles),
        );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    return await FirebaseAuth.instance.signInWithProvider(googleProvider);
  }

  void googleSignIn(BuildContext context) {
    if (kIsWeb) {
      FirebaseAuth.instance
        .signInWithPopup(GoogleAuthProvider())
        .then(
          (credentials) => socialAuth(
              auth: SignInMethods.google,
              credentials: credentials,
              context: context),
        )
        .onError(
          (FirebaseAuthException error, stackTrace) => _resolveAuthError(
            error: error,
            context: context,
            signInMethods: SignInMethods.google,
          ),
        );
    } else {
      signInWithGoogle()
        .then((credentials) => socialAuth(
            auth: SignInMethods.google,
            credentials: credentials,
            context: context))
        .onError(
          (FirebaseAuthException error, stackTrace) => _resolveAuthError(
            error: error,
            context: context,
            signInMethods: SignInMethods.google,
          ),
        );
    }
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  void githubSignIn(BuildContext context) {
    if (kIsWeb) {
      FirebaseAuth.instance
        .signInWithPopup(GithubAuthProvider())
        .then(
          (credentials) => socialAuth(
              auth: SignInMethods.github,
              credentials: credentials,
              context: context),
        )
        .onError(
          (FirebaseAuthException error, stackTrace) => _resolveAuthError(
            error: error,
            context: context,
            signInMethods: SignInMethods.github,
          ),
        );
    } else {
      signInWithGitHub()
        .then((credentials) => socialAuth(
            auth: SignInMethods.github,
            credentials: credentials,
            context: context))
        .onError(
          (FirebaseAuthException error, stackTrace) => _resolveAuthError(
            error: error,
            context: context,
            signInMethods: SignInMethods.google,
          ),
        );
    }
  }

  void authUser({
    required BuildContext context,
    required SignInMethods signInMethods,
    String? email,
    String? password,
  }) async {
    switch (signInMethods) {
      case SignInMethods.email:
        FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((_) => init())
          .then((_) => GlobalNavigator.router.currentState!
              .pushReplacementNamed(GlobalRoutes.switchRoles))
          .then((value) => AppData.checkUserIfVerified())
          .onError(
            (FirebaseAuthException error, stackTrace) => _resolveAuthError(
              error: error,
              context: context,
              signInMethods: SignInMethods.email,
            ),
          );
        break;
      case SignInMethods.google:
        googleSignIn(context);
        break;
      case SignInMethods.github:
        githubSignIn(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          alertSnackBar(message: "Unable to Sign In try again"),
        );
    }
  }

  void signOut(BuildContext context) {
    try {
      FirebaseAuth.instance.signOut();
      _user = UserModel.clear();
      Var.appTitle = "";
      Var.activePage = "";
      Var.activeUserRole = "";
      Var.previousRoute = "";
      notifyListeners();
      UserProvider.clearUserLists();
      GlobalNavigator.router.currentState!
          .pushReplacementNamed(AuthRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        alertSnackBar(message: "Unable to Logout"),
      );
    }
  }

  void resetPassword({required String email}) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then(
          (value) => alertSnackBar(
              message:
                  "Password reset request succesfully sent, check your email"),
        )
        .catchError(
          (error) => alertSnackBar(
              message: "Unable to send request, ${error.toString()}"),
        )
        .then((value) => GlobalNavigator.router.currentState
            ?.pushReplacementNamed(AuthRoutes.splash));
  }

  void storeNewUser(
    uid,
    email,
    password,
    name,
    phone,
    address,
    role,
    companyName,
    permit,
    license,
    dti,
    sec,
    validID,
    isUserVerified
  ) async {
    await FirebaseFirestore.instance
      .collection(Var.users)
      .doc(uid)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel userModel, _) =>
            userModel.toFirestore())
      .set(
        UserModel(
          uid: uid,
          email: email,
          password: password,
          name: name,
          phone: phone,
          address: address,
          roles: role,
          companyName: companyName,
          permit: permit,
          license: license,
          dti: dti,
          sec: sec,
          validID: validID,
          isUserVerified: isUserVerified
        ),
      );
    Toast.show("Successfully Registered new user!");
    GlobalNavigator.router.currentState!
      .popAndPushNamed(AuthRoutes.onboarding);
  }

  static void userRegister({
    required String username,
    required BuildContext context,
    required String email,
    required String password,
    required String phone,
    required Address address,
    required String role,
    required String companyName,
    String? permit,
    String? license,
    String? dti,
    String? sec,
    String? validID,
    String? isUserVerified
  }) {
    Loader.show(context, 0);
    Provider.of<UserProvider>(context, listen: false).createUser(
      context: context,
      signInMethods: SignInMethods.email,
      payload: UserModel(
        name: username,
        email: email,
        password: password,
        phone: phone,
        address: address,
        roles: role,
        companyName: companyName,
        permit: permit,
        license: license,
        dti: dti,
        sec: sec,
        validID: validID,
        isUserVerified: isUserVerified
      )
    );
  }

  static UserModel? getUserDetails(userId) {
    UserModel? res;
    FirebaseFirestore.instance
      .collection(Var.users)
      .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel userModel, _) => userModel.toFirestore())
      .doc(userId)
      .get()
      .then((value) {
      res = value.data();
    });
    return res;
  }

  // static Future<String?> getUserRole(userId, UserModel? res) async {
  static void getUserRole(userId, UserModel? res) async {
    await FirebaseFirestore.instance
      .collection(Var.users)
      .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel userModel, _) => userModel.toFirestore())
      .doc(userId)
      .get()
      .then((value) {
      Var.activeUserRole = value.data()?.roles ?? Var.na;
      // return value.data()?.roles ?? Var.na;
    });
  }

  UserModel getUser(String uid) {
    UserModel user = UserModel.clear();
    FirebaseFirestore.instance
        .collection(Var.users)
        .doc(uid)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel userModel, _) => userModel.toFirestore())
        .get()
        .then((value) => user = value.data()!);
    return user;
  }

  static void clearUserLists() {
    Var.filteredClientUsers.clear();
    Var.notifLists.clear();
    AppData.getContractorUser();
    AppData.getClientUser();
  }

}
