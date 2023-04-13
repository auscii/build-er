import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/models/user.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../router/navigator/navigation_menu.dart';
import '../../styles/icons/builder_icons.dart';

class SwitchRoles extends StatefulWidget {
  static const String id = "switch_roles";
  const SwitchRoles({super.key});

  @override
  State<SwitchRoles> createState() => _SwitchRolesState();
}

class _SwitchRolesState extends State<SwitchRoles> {

  @override
  void initState() {
    _getUserRoles();
    super.initState();
  }

  void _navToRole(String role) {
    String route;
    if (role == Var.client) {
      route = PagesRoutes.client;
    } else if (role == Var.contractor) {
      route = PagesRoutes.user; 
    } else if (role == Var.admin) {
      route = PagesRoutes.admin; 
    } else {
      route = SharedRoutes.profile;
    }
    GlobalNavigator.router.currentState!
        .pushReplacementNamed(NavigationMenu.id, arguments: route);
  }

  IconData _getRoleIcon(Roles role) {
    switch (role) {
      case Roles.admin:
        return ProjectBuilder.admin;
      case Roles.user:
        return ProjectBuilder.user;
      case Roles.client:
        return ProjectBuilder.car;
      default:
        return ProjectBuilder.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.zero,
                child: const Center(
                  child: 
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CupertinoActivityIndicator(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUserRoles() {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    UserProvider.getUserRole(
      uid, UserModel(uid: uid)
    );
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        _navToRole(Var.activeUserRole);
      });
    });
  }

}
