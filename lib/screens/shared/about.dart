import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import '../../router/navigator/navigation_menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const id = "about";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(Var.lightBg),
              fit: BoxFit.cover,
            ),
          ),
          child: ConstrainedBox(
            constraints: pageConstraints,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    Image.asset(
                      Var.appLogo,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),
                    const Text(
                      "${Var.about} ${Var.builder}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      Var.builderTagline,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.zero,
                      width: 350,
                      child: Column(
                        children: const <Widget>[
                          Text(
                            Var.aboutBuilder,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.black, thickness: 1, height: 1),
                    const SizedBox(height: 25),
                    const Text(
                      Var.services,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.zero,
                      width: 350,
                      child: Column(
                        children: const <Widget>[
                          Text(
                            Var.servicesInfo,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.black, thickness: 1, height: 1),
                    const SizedBox(height: 25),
                    // const Text(
                    //   Var.keyFeatures,
                    //   style: TextStyle(
                    //     fontFamily: Var.defaultFont,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 25,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.zero,
                      width: 450,
                      height: 200,
                      child: Image.asset(
                        Var.keyFeaturesImg,
                        width: 350,
                        height: 150,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.zero,
                      width: 350,
                      height: 100,
                      child: Image.asset(
                        Var.reviewsImg,
                        width: 350,
                        height: 150,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.black, thickness: 1, height: 1),
                    const SizedBox(height: 25),
                    const Text(
                      Var.partners,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.zero,
                      width: 350,
                      height: 200,
                      child: Image.asset(
                        Var.partnersImg,
                        width: 350,
                        height: 150,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}
