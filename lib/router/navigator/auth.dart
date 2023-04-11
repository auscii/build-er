import 'package:flutter/material.dart';
import '../router.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);
  static const String id = "auth";
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalNavigator.router,
      initialRoute: GlobalNavigator.initialRoute(),
      onGenerateRoute: GlobalNavigator.generateRoute,
    );
  }
}
