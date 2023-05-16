import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:client/router/navigator/navigation_menu.dart';
import 'package:client/router/router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = Var.splash;
  const SplashScreen({Key? key}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // AppData.initApplication();
    Future.wait([Future.delayed(const Duration(seconds: 3))]).whenComplete(
      () => GlobalNavigator.navigateToScreen(const NavigationMenu())
    );
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   Future.wait([Future.delayed(const Duration(seconds: 3))]).whenComplete(
  //     () => GlobalNavigator.navigateToScreen(const NavigationMenu())
  //   );
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.zero,
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Image.asset(
          Var.splashBG,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      )
    );
    /*
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: 
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 160),
                        Center(
                          child: TweenAnimationBuilder(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(seconds: 1),
                            child: 
                              Image.asset(
                                Var.startupBg,
                                // width: 250,
                                // height: 250,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                filterQuality: FilterQuality.high,
                              ),
                            builder: (ctx, double opacity, child) => Opacity(
                              opacity: opacity,
                              child: child,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 25,
                          child: 
                          CustomScrollView(
                            slivers: [
                              Loader.indicator(250.0, Colors.black)
                            ],
                          )
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                ),
              ),
          ),
        );
      });
      */
  }

}