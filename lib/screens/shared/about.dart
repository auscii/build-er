import 'package:flutter/material.dart';

// 🏘️ Local imports
import '../../core/utils/global.dart';
import '../../router/navigator/navigation_menu.dart';
import '../../styles/icons/builder_icons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static const id = "about";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 0, left: 30, right: 30),
      maintainBottomViewPadding: false,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                Var.about,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                Var.appLogo,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 24),
              const Text(
                Var.aboutBuilder,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
