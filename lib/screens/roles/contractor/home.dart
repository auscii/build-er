import 'package:client/core/utils/global.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../router/navigator/navigation_menu.dart';

class ContractorHome extends StatefulWidget {
  static const String id = Var.contractorHome;
  const ContractorHome({Key? key}) : super(key: key);

  @override
  State<ContractorHome> createState() => _ContractorHomeState();
}

class _ContractorHomeState extends State<ContractorHome> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildStats({
    required BuildContext context,
    required String label,
    // required VoidCallback onPressed,
    required double cummulative,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.157),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 40,
                  child: SvgPicture.asset(
                    cummulative.isNegative
                        ? "assets/images/res/graph_down.svg"
                        : "assets/images/res/graph_up.svg",
                    height: 16,
                    width: 60,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SizedBox(
                  height: 6,
                  child: SvgPicture.asset(
                    cummulative.isNegative
                        ? "assets/images/res/loss.svg"
                        : "assets/images/res/gain.svg",
                    height: 6,
                    width: 6,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(
                  "${cummulative.isNegative ? '' : '+'}$cummulative%",
                  style: TextStyle(
                    color: cummulative.isNegative
                      ? const Color.fromRGBO(226, 80, 122, 1)
                      : const Color.fromRGBO(80, 226, 193, 1),
                    fontSize: 11,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 30, left: 36, right: 36),
      maintainBottomViewPadding: false,
      child: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  Var.appLogo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                const Text(
                  Var.builder,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  Var.builderTagline,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
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
    );
  }
}