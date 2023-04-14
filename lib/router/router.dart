import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/screens/auth/contractor_register.dart';
import 'package:client/screens/roles/admin/users_lists.dart';
import 'package:client/screens/roles/client/components/product_details.dart';
import 'package:client/screens/roles/client/ecommerce.dart';
import 'package:client/screens/roles/contractor/portfolio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth/resetPassword.dart';
import '../screens/roles/admin/admin_products.dart';
import '../screens/shared/about.dart';
import 'navigator/auth.dart';
import 'navigator/navigation_menu.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/onboarding.dart';
import '../screens/auth/client_register.dart';
import '../../screens/roles/admin/home.dart';
import '../../screens/roles/client/home.dart';
import '../../screens/roles/switch_roles.dart';
import '../screens/roles/contractor/home.dart';
import '../../screens/shared/profile.dart';
import '../../screens/shared/settings.dart';
import 'routes.dart';

class GlobalNavigator {
  static GlobalKey<NavigatorState> router = GlobalKey();

  static void pushReplace(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  static void pushNamed(BuildContext context, String name) {
    Navigator.pushNamed(context, name);
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  static void pushReplaceNav(BuildContext context, int value) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => NavigationMenu(activeIndex: value))
    );
  }

  static void popAndPush(BuildContext context, String value) {
    Navigator.popAndPushNamed(context, value);
  }

  static void restorePopAndPush(BuildContext context, String name) {
    Navigator.restorablePopAndPushNamed(context, name);
  }

  static void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      )
    );
  }

  static Future<dynamic> replaceScreen(Widget page, {arguments}) 
    async => router.currentState?.pushReplacement(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  );

  static Future<dynamic> navigateToScreen(Widget page, {arguments}) 
    async => router.currentState?.push(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  );

  static dynamic goBack([dynamic popValue]) {
    return router.currentState?.pop(popValue);
  }

  static void popToFirst() => router.currentState?.popUntil((route) 
    => route.isFirst);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case GlobalRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AuthNavigator());
      case GlobalRoutes.pages:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => NavigationMenu(
            routeToNavigate: settings.arguments as String,
            activeIndex: 0,
          ),
        );
      case GlobalRoutes.switchRoles:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SwitchRoles());
      case PagesRoutes.user:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const NavigationMenu(
            routeToNavigate: PagesRoutes.user,
            activeIndex: 0,
          ),
        );
      case AuthRoutes.splash:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const Splash());
      case AuthRoutes.onboarding:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const Onboarding());
      case AuthRoutes.login:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const Login());
      case AuthRoutes.clientRegister:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const ClientRegister());
      case AuthRoutes.contractorRegister:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const ContractorRegister());
      case AuthRoutes.resetPassword:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => ResetPassword());
      case PagesRoutes.ecommerce:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const Ecommerce());
      case PagesRoutes.productDetails:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const ProductDetails());
      case PagesRoutes.adminProducts:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const AdminProducts());
      case PagesRoutes.userLists:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const UserLists());
      case PagesRoutes.portfolio:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const PortfolioScreen());
      default:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AuthNavigator());
    }
  }

  static String initialRoute() {
    AppData.getProductLists();
    AppData.getUserLists();
    AppData.getPortfolioLists();
    AppData.getContractorUser();
    AppData.getClientUser();
    AppData.checkUserIfVerified();
    if (FirebaseAuth.instance.currentUser == null) {
      return AuthRoutes.onboarding; //GlobalRoutes.auth;
    } else {
      return PagesRoutes.user;
    }
  }

  static void doubleGoBack() {
    GlobalNavigator.goBack();
    GlobalNavigator.goBack();
  }

}

class PageRouter {
  static const initialRoute = PagesRoutes.user;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page = const ContractorHome();

    switch (settings.name) {
      case PagesRoutes.requestRole:
        page = const ContractorHome();
        break;
      case PagesRoutes.admin:
        page = const AdminHome();
        break;
      case PagesRoutes.client:
        page = const ClientHome();
        break;
      case PagesRoutes.user:
        page = const ContractorHome();
        break;
      case SharedRoutes.profile:
        page = ProfilePage();
        break;
      case SharedRoutes.settings:
        page = const SettingsPage();
        break;
      case SharedRoutes.about:
        page = const AboutPage();
        break;
      case SharedRoutes.ecommerce:
        page = const Ecommerce();
        break;
      case PagesRoutes.portfolio:
        page = const PortfolioScreen();
        break;
      default:
        page = const ContractorHome();
        break;
    }

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 1),
    );
  }
}
