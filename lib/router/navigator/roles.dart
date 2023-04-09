import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🏘️ Local imports
import '../../core/models/user.dart';
import '../../core/providers/appdata.dart';
import '../../core/providers/user.dart';
import '../../core/utils/global.dart';
import '../router.dart';
import '../routes.dart';
import '../../styles/icons/builder_icons.dart';
import '../../../styles/ui/colors.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class PageNavigator extends StatelessWidget {
  PageNavigator({
    ///* Auto Navigates to a given Page
    this.routeToNavigate = PageRouter.initialRoute,
    Key? key,
  }) : super(key: key);

  final String routeToNavigate;

  static const String id = "roles_manager";
  static GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageNavigator.scaffold,
      backgroundColor: AppColors.bgDark,
      drawer: customDrawer(context),
      body: Stack(
        children: <Widget>[
          Navigator(
            key: PageRouter.router,
            initialRoute: routeToNavigate,
            onGenerateRoute: PageRouter.generateRoute,
          ),
          const PageAppBar(),
        ],
      ),
    );
  }

  Drawer customDrawer(BuildContext context) {
    // Widget logoutButton() {
    //   return SizedBox(
    //     height: kIsWeb ? 50 : null,
    //     child: ElevatedButton(
    //       onPressed: () 
    //         => Provider.of<UserProvider>(context, listen: false).signOut(context),
    //       style: ElevatedButton.styleFrom(
    //         primary: AppColors.primary,
    //         padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 40),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(16),
    //         ),
    //       ),
    //       child: const Text(
    //         Var.logout,
    //         style: TextStyle(
    //           fontFamily: Var.defaultFont,
    //           fontSize: 20,
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    Widget profile() {
      return GestureDetector(
        onTap: () => PageRouter.router.currentState!
            .pushReplacementNamed(SharedRoutes.profile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CircleAvatar(
            //   minRadius: 30,
            //   maxRadius: 60,
            //   backgroundColor: AppColors.input.withOpacity(0.7),
            //   backgroundImage: NetworkImage(
            //     Provider.of<UserProvider>(context).user.profilePhoto,
            //   ),
            // ),
            Image.asset(
              Var.appLogo,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(height: 20),
            Text(
              "${Provider.of<UserProvider>(context).user.name}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: "SF Pro Rounded",
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
    }

    /* buildRoles(BuildContext context) {
      void navToRole(Roles role) {
        String route;

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

        Provider.of<AppData>(context, listen: false).changeRoute(route);
        PageRouter.router.currentState!.pushReplacementNamed(route);
      }

      IconData getRoleIcon(Roles role) {
        switch (role) {
          case Roles.admin:
            return ProjectBuilder.admin;
          case Roles.user:
            return ProjectBuilder.home;
          case Roles.client:
            return ProjectBuilder.car;
          default:
            return ProjectBuilder.info;
        }
      }

      String getLabel(Roles role) {
        switch (role) {
          case Roles.admin:
            return "Admin";
          case Roles.user:
            return "Home";
          case Roles.client:
            return "Client";
          default:
            return "User ⚠";
        }
      }

      try {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: Provider.of<UserProvider>(context)
              .user
              .roles
              .map((role) => navLink(
                    onPressed: () => navToRole(role),
                    icon: getRoleIcon(role),
                    label: getLabel(role),
                  ))
              .toList(),
        );
      } catch (e) {
        return navLink(
            icon: ProjectBuilder.home,
            label: "Home ⚠",
            onPressed: () {
              Provider.of<AppData>(context, listen: false)
                  .changeRoute(SharedRoutes.about);
              PageRouter.router.currentState!
                  .pushReplacementNamed(SharedRoutes.profile);
            });
      }
    } */

    return Drawer(
      width: 260,
      child: Center(
        child: 
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  profile(),
                  const SizedBox(height: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildRoles(context),
                      navLink(
                        icon: ProjectBuilder.user,
                        label: Var.profile,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.profile);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.profile);
                        },
                      ),
                      navLink(
                        icon: ProjectBuilder.info,
                        label: Var.about,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.about);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.about);
                        },
                      ),
                      navLink(
                        icon: ProjectBuilder.products,
                        label: Var.ecommerce,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.shoppingCart);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.shoppingCart);
                        },
                      ),
                      navLink(
                        icon: ProjectBuilder.products,
                        label: Var.logout,
                        onPressed: ()
                        => Provider.of<UserProvider>(context, listen: false)
                          .signOut(context),
                      ),
                    ]
                  ),
                ],
              ),
          )
      ),
    );
  }

  Widget navLink({
    IconData? icon = ProjectBuilder.info,
    String label = "Link",
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: TextButton.styleFrom(
        primary: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        textStyle: const TextStyle(
          fontFamily: Var.defaultFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      label: Text(label),
    );
  }
}

class PageAppBar extends StatelessWidget {
  const PageAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: AppColors.bgDark),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  PageNavigator.scaffold.currentState!.openDrawer();
                },
                icon: const Icon(ProjectBuilder.menu)),
            Text(
              Provider.of<AppData>(context).currentRoute,
              style: const TextStyle(
                fontFamily: Var.defaultFont,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(ProjectBuilder.light))
          ],
        ),
      ),
    );
  }
}
