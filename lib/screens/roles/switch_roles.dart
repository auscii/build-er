import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/models/user.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../router/navigator/roles.dart';
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
    Future.delayed(const Duration(milliseconds: 2500),() {
      setState(() => _navToRole(Roles.client));
    });
    super.initState();
  }

  void _navToRole(Roles role) {
    String route;
    role = Roles.user;

    switch (role) {
      case Roles.admin:
        route = PagesRoutes.admin;
        break;
      case Roles.user:
        route = PagesRoutes.user;
        break;
      case Roles.client:
        route = PagesRoutes.client;
        break;
      default:
        route = SharedRoutes.profile;
    }

    GlobalNavigator.router.currentState!
        .pushReplacementNamed(PageNavigator.id, arguments: route);
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

  /* Widget _generateRoles(BuildContext context) {
    Widget roleItem(Roles role) => ElevatedButton(
          onPressed: () => _navToRole(role),
          style: ElevatedButton.styleFrom(
            primary: AppColors.bgDark,
            onSurface: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 19),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Icon(_getRoleIcon(role), size: 25, color: AppColors.primary),
        );

    try {
      if (Provider.of<UserProvider>(context).user == UserModel.clear()) {
        return const Center(child: Text("Fetching Roles"));
      } else {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Provider.of<UserProvider>(context)
                .user
                .roles
                .map((role) => roleItem(role))
                .toList(),
          ),
        );
      }
    } catch (e) {
      return const Center(child: Text("Unable to fetch Roles"));
    }
  } */

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
}
