import 'package:client/core/providers/appdata.dart';
import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../router/navigator/roles.dart';
import '../../../styles/icons/builder_icons.dart';
import '../admin/home.dart';
import '../admin/items.dart';
import '../user/home.dart';

class ClientHome extends StatefulWidget {
  static const String id = "client";
  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {

  @override
  void initState() {
    print("initstate on home client page.");
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
    return SafeArea(
      minimum: const EdgeInsets.only(top: 130, left: 36, right: 36),
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
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.zero,
                  width: 350,
                  child: Column(
                    children: const <Widget>[
                      Text(
                        Var.aboutBuilder,
                        textAlign: TextAlign.justify,
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
                    fontSize: 25,
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
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  Var.stanleyLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.dewaltLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.makitaLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 25),
                const Divider(color: Colors.black, thickness: 1, height: 1),
                const SizedBox(height: 25),
                const Text(
                  Var.partners,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.asec,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.asecLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.asecBuilding,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.asdec,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.asdecLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.asdecSmCoast,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.cki,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.ckiLogo,
                  width: 350,
                  height: 250,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.ckiRestau,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.datem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.datemLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.datemBuilding,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.ffCruz,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.ffLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.ffFishport,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                const Text(
                  Var.monolithConstruction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Image.asset(
                  Var.monolithLogo,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Var.monolithMoaArena,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 35),
                /*
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStats(
                            context: context,
                            label: "Daily",
                            cummulative: -5.23,
                            // onPressed: () => showDialog(
                            //   context: context,
                            //   builder: (context) => const SearchOverlay(),
                            // ),
                          ),
                          const SizedBox(width: 10),
                          _buildStats(
                            context: context,
                            label: "Weekly",
                            cummulative: 39.69,
                            // onPressed: () => showDialog(
                            //   context: context,
                            //   builder: (context) => const SearchOverlay(),
                            // ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                */
                const SizedBox(height: 20),
                /*
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Service Requests",
                        style: TextStyle(
                          fontFamily: Var.defaultFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 27),
                      Expanded(
                        child: TabbedLayout(
                          tabLabel: ["New Requests", "Completed"],
                          tabs: [NewRequests(), CompletedRequests()],
                        ),
                      )
                    ],
                  ),
                ),
                */
              ],
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
                ?? Var.userPlaceholder,
            ),
          icon: const Icon(ProjectBuilder.add),
          onPressed: () {
            instance.updateServiceRequest(
              completed: false,
              uid: instance.serviceRequestN[i].userId,
            );
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
              ?? Var.userPlaceholder,
          ),
          icon: const Icon(ProjectBuilder.info),
        ),
      ),
    );
  }
}
