import 'package:client/core/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🏘️ Local imports
import '../../core/models/user.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../router/navigator/roles.dart';
import '../../styles/icons/builder_icons.dart';
import '../../styles/ui/colors.dart';

class SwitchRoles extends StatelessWidget {
  const SwitchRoles({Key? key}) : super(key: key);

  static const String id = "switch_roles";

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
      case Roles.garage:
        route = PagesRoutes.garage;
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
      case Roles.garage:
        return ProjectBuilder.car;
      default:
        return ProjectBuilder.info;
    }
  }

  Widget _generateRoles(BuildContext context) {
    Widget roleItem(Roles role) => ElevatedButton(
          onPressed: () => _navToRole(role),
          // onPressed: () {
          //   print("navigate to PagesRoutes.user");
          //   GlobalNavigator.router.currentState!
          //       .pushReplacementNamed(PageNavigator.id, arguments: PagesRoutes.user);
          // },
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose which Role to log into",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              _generateRoles(context),
            ],
          ),
        ),
      ),
    );
  }
}
