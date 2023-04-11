import 'package:client/router/navigator/menu_drawer.dart';
import 'package:client/screens/roles/client/locator.dart';
import 'package:client/screens/roles/user/shopping_cart.dart';
import 'package:client/screens/shared/about.dart';
import 'package:client/screens/shared/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import '../../screens/roles/client/home.dart';
import '../router.dart';
import '../../styles/icons/builder_icons.dart';
import '../../../styles/ui/colors.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class NavigationMenu extends StatefulWidget {
  final String routeToNavigate;
  static int activeIndex = 0;
  static const String id = "roles_manager";
  const NavigationMenu({
    this.routeToNavigate = PageRouter.initialRoute,
    Key? key,
    int? activeIndex,
  }) : super(key: key);
  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  static CupertinoTabView? returnValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      drawer: const MenuDrawer(),//customDrawer(context),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          Var.builder,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: Var.defaultFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        // actions: [NotificationButton()],
        leading: Builder(builder: (context) {
          return IconButton(
            padding: const EdgeInsets.only(left: 16, right: 16),
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
            alignment: Alignment.centerLeft,
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          onTap: (value) {
            setState(() => NavigationMenu.activeIndex = value);
            if (value == 0) {
              NavigationMenu.activeIndex = 0;
              GlobalNavigator.replaceScreen(const NavigationMenu(activeIndex: 0));
            } else if (value == 1) {
              NavigationMenu.activeIndex = 1;
            }
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          backgroundColor: Colors.black,
          height: 55,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe318,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.home
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe491,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.profile,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe2dc,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.capsContractor,
            ),
          ],
        ),
        tabBuilder: (context, index) {
          index = NavigationMenu.activeIndex;
          var home = CupertinoTabView(builder: (context) => const ClientHome());
          switch (index) {
            case 0:
              returnValue = home;
              break;
            case 1:
              returnValue = CupertinoTabView(builder: (context) => ProfilePage());
              break;
            case 2:
              returnValue = CupertinoTabView(builder: (context) => const Locator());
              break;
            case 3:
              returnValue = CupertinoTabView(builder: (context) => ShoppingCart());
              break;
          }
          return returnValue ?? home;
        },
      )
    );
  }

  /*
  Drawer customDrawer(BuildContext context) {
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
                fontFamily: Var.defaultFont,
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
              .map((role) => _navItem(
                    onPressed: () => navToRole(role),
                    icon: getRoleIcon(role),
                    label: getLabel(role),
                  ))
              .toList(),
        );
      } catch (e) {
        return _navItem(
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
      surfaceTintColor: Colors.black,
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
                  Var.activeUserRole == Var.client ?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildRoles(context),
                      _navItem(
                        icon: ProjectBuilder.home,
                        label: Var.home,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(PagesRoutes.client);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(PagesRoutes.client);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.user,
                        label: Var.profile,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.profile);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.profile);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.info,
                        label: Var.about,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.about);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.about);
                        },
                      ),
                      _navItem(
                        icon: 
                          const IconData(
                            0xee4b,
                            fontFamily: Var.materialIcons
                          ),
                        label: Var.ecommerce,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.shoppingCart);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.shoppingCart);
                        },
                      ),
                      _navItem(
                        icon: 
                          const IconData(
                            0xe3ae,
                            fontFamily: Var.materialIcons
                          ),
                        label: Var.logout,
                        onPressed: ()
                        => Provider.of<UserProvider>(context, listen: false)
                          .signOut(context),
                      ),
                    ]
                  ) :
                  Var.activeUserRole == Var.contractor ?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildRoles(context),
                      _navItem(
                        icon: ProjectBuilder.home,
                        label: Var.home,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(PagesRoutes.user);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(PagesRoutes.user);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.user,
                        label: Var.profile,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.profile);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.profile);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.lock,
                        label: Var.logout,
                        onPressed: ()
                        => Provider.of<UserProvider>(context, listen: false)
                          .signOut(context),
                      ),
                    ]
                  ) : 
                  // Admin
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _navItem(
                        icon: ProjectBuilder.user,
                        label: Var.users,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.profile);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.profile);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.info,
                        label: Var.products,
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .changeRoute(SharedRoutes.about);
                          PageRouter.router.currentState!
                              .pushReplacementNamed(SharedRoutes.about);
                        },
                      ),
                      _navItem(
                        icon: ProjectBuilder.lock,
                        label: Var.logout,
                        onPressed: ()
                        => Provider.of<UserProvider>(context, listen: false)
                          .signOut(context),
                      ),
                    ]
                  )
                ],
              ),
          )
      ),
    );
  }
  */

  Widget _navItem({
    IconData? icon = ProjectBuilder.info,
    String label = Var.na,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
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
/*
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
                  NavigationMenu.scaffold.currentState!.openDrawer();
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
*/