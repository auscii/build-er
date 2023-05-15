import 'package:client/core/providers/appdata.dart';
import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/icons/builder_icons.dart';
import '../admin/add_products.dart';

class ClientHome extends StatefulWidget {
  static const String id = Var.client;
  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {

  @override
  void initState() {
    setState(() => Var.activePage = Var.home);
    AppData.clearPortfolioLists();
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        AppData.getPortfolioLists();
      });
    });
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
          color: AppColors.bgDark,
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
    Container(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.phone_android),
          label: const Text("Authenticate using Phone"),
        ),
      ),
    );
    return SafeArea(
      // minimum: const EdgeInsets.only(top: 30),
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
              // colorFilter: ColorFilter.mode(
              //   Colors.black.withOpacity(.6),
              //   BlendMode.darken,
              // ),
            ),
          ),
          child: ConstrainedBox(
            constraints: pageConstraints,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 15),
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
                        color: Colors.black
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

class NewRequests extends StatelessWidget {
  const NewRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, instance, child) => ListView.separated(
        padding: const EdgeInsets.all(5),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: instance.serviceRequestN.length,
        itemBuilder: (_, i) 
          => RoundedTile(
          label: 
            UserProvider.getUserDetails(
              instance.serviceRequestN[i].userId)?.name,
          avatar: 
            Image.network(
              UserProvider.getUserDetails(
                instance.serviceRequestN[i].userId)?.profilePhoto
                ?? Var.noImageAvailable,
            ),
          icon: const Icon(ProjectBuilder.add),
          onPressed: () {
            // instance.updateServiceRequest(
            //   completed: false,
            //   uid: instance.serviceRequestN[i].userId,
            // );
          },
        ),
      ),
    );
  }
}

class CompletedRequests extends StatelessWidget {
  const CompletedRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, instance, child) => ListView.separated(
        padding: const EdgeInsets.all(5),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: instance.serviceRequestC.length,
        itemBuilder: (_, i) => RoundedTile(
          label: UserProvider.getUserDetails(
            instance.serviceRequestC[i].userId)?.name,
          avatar: Image.network(
            UserProvider.getUserDetails(
              instance.serviceRequestC[i].userId)?.profilePhoto
              ?? Var.noImageAvailable,
          ),
          icon: const Icon(ProjectBuilder.info),
        ),
      ),
    );
  }
}
