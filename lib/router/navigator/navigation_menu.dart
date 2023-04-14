import 'package:client/router/navigator/menu_drawer.dart';
import 'package:client/screens/roles/admin/admin_products.dart';
import 'package:client/screens/roles/admin/home.dart';
import 'package:client/screens/roles/admin/users_lists.dart';
import 'package:client/screens/roles/client/components/product_details.dart';
import 'package:client/screens/roles/client/ecommerce.dart';
import 'package:client/screens/roles/client/locator.dart';
import 'package:client/screens/roles/contractor/home.dart';
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
    const BoxConstraints(minWidth: 320, maxWidth: 480, maxHeight: 1000, minHeight: 350);

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
            } else if (value == 2) {
              NavigationMenu.activeIndex = 2;
            }
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          backgroundColor: Colors.black,
          height: 55,
          items: Var.activeUserRole == Var.client ?
          const <BottomNavigationBarItem>[
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
                  0xe59c,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.ecommerce,
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
          ] :
          Var.activeUserRole == Var.contractor ?
          const <BottomNavigationBarItem>[
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
                  0xf0891,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.profile,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xf0541,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.portfolio,
            ),
          ] :
          <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe318,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.home
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                IconData(
                  0xe61e,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.users.toUpperCase(),
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xec90,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.products,
            ),
          ],
        ),
        tabBuilder: (context, index) {
          CupertinoTabView? home;
          index = NavigationMenu.activeIndex;
          home = 
          Var.activeUserRole == Var.client ? 
          CupertinoTabView(builder: (context) => const ClientHome()) :
          Var.activeUserRole == Var.contractor ?
          CupertinoTabView(builder: (context) => const ContractorHome()) :
          CupertinoTabView(builder: (context) => const AdminHome());
          switch (index) {
            case 0:
              returnValue = home;
              break;
            case 1:
              returnValue
              = Var.activeUserRole == Var.client ? 
                CupertinoTabView(builder: (context) => const Ecommerce()) :
                Var.activeUserRole == Var.contractor ?
                CupertinoTabView(builder: (context) => const ContractorHome()) :
                CupertinoTabView(builder: (context) => const UserLists());
              // returnValue = CupertinoTabView(builder: (context) => const Ecommerce());
              break;
            case 2:
              returnValue
              = Var.activeUserRole == Var.client ? 
                CupertinoTabView(builder: (context) => const Locator()) :
                Var.activeUserRole == Var.contractor ?
                CupertinoTabView(builder: (context) => const ContractorHome()) :
                CupertinoTabView(builder: (context) => const AdminProducts());
              // returnValue = CupertinoTabView(builder: (context) => const Locator());
              break;
            case 3:
              returnValue = CupertinoTabView(builder: (context) => ProfilePage());
              break;
            case 4:
              returnValue = CupertinoTabView(builder: (context) => const AboutPage());
              break;
            case 5:
              returnValue = CupertinoTabView(builder: (context) => const ProductDetails());
              break;
            case 6:
              returnValue = CupertinoTabView(builder: (context) => const AdminProducts());
              break;
          }
          return returnValue ?? home;
        },
      )
    );
  }

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