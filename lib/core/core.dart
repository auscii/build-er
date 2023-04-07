import 'package:client/core/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/location.dart';
import 'providers/appdata.dart';
import 'providers/user.dart';
import '../styles/ui/colors.dart';
import '../router/router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppData()),
      ],
      child: MaterialApp(
        title: Var.builder,
        theme: ThemeData(
          // scaffoldBackgroundColor: AppColors.bgDark,
          fontFamily: Var.defaultFont,
        ),
        darkTheme: ThemeData.light(), //ThemeData.dark(),
        navigatorKey: GlobalNavigator.router,
        initialRoute: GlobalNavigator.initialRoute(),
        onGenerateRoute: GlobalNavigator.generateRoute,
      ),
    );
  }
}
