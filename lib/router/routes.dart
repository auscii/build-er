import 'package:client/screens/roles/admin/admin_products.dart';
import 'package:client/screens/roles/admin/users_lists.dart';
import 'package:client/screens/roles/client/components/product_details.dart';
import 'package:client/screens/roles/client/ecommerce.dart';
import 'package:client/screens/roles/client/locator.dart';

import '../screens/auth/contractor_register.dart';
import '../screens/auth/resetPassword.dart';
import 'navigator/auth.dart';
import 'navigator/navigation_menu.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/onboarding.dart';
import '../screens/auth/client_register.dart';
import '../../screens/roles/admin/home.dart';
import '../../screens/roles/client/home.dart';
import '../../screens/roles/switch_roles.dart';
import '../screens/roles/contractor/home.dart';

class GlobalRoutes {
  static const String auth = AuthNavigator.id;
  static const String pages = NavigationMenu.id;
  static const String switchRoles = SwitchRoles.id;
}

class AuthRoutes {
  static const String splash = Splash.id;
  static const String onboarding = Onboarding.id;
  static const String login = Login.id;
  static const String clientRegister = ClientRegister.id;
  static const String contractorRegister = ContractorRegister.id;
  static const String resetPassword = ResetPassword.id;
}

class SharedRoutes {
  static const String settings = "settings";
  static const String profile = "profile";
  static const String about = "about";
  static const String ecommerce = Ecommerce.id;
}

class PagesRoutes {
  static const String admin = AdminHome.id;
  static const String user = ContractorHome.id;
  static const String client = ClientHome.id;
  static const String requestRole = "request_role";
  static const String locator = Locator.id;
  static const String ecommerce = Ecommerce.id;
  static const String productDetails = ProductDetails.id;
  static const String adminProducts = AdminProducts.id;
  static const String userLists = UserLists.id;
}