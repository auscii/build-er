import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🏘️ Local imports
import '../../../core/models/user.dart';
import '../../../styles/icons/builder_icons.dart';
import '../../../core/providers/appdata.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/ui/colors.dart';
import 'add_products.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  static const String id = "admin";

  Widget _buildAddItem({
    required BuildContext context,
    required String label,
    required GestureTapCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: DottedBorder(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          borderType: BorderType.RRect,
          dashPattern: const [4, 4],
          radius: const Radius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      minimum: const EdgeInsets.only(top: 20, left: 36, right: 36),
      maintainBottomViewPadding: false,
      child: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(15),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      const TextSpan(text: "${Var.welcome}\n"),
                      TextSpan(
                        text: Provider.of<UserProvider>(context).user.name,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Admin Tasks",
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAddItem(
                          context: context,
                          label: Var.addProduct,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AddProduct(
                              admin: true,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10),
                        // _buildAddItem(
                        //   context: context,
                        //   label: "+ Add Admin",
                        //   onPressed: () => showDialog(
                        //     context: context,
                        //     builder: (context) => const AddAdmin(),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Users Verification",
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: TabbedLayout(
                        tabLabel: ["CONTRACTOR REQUESTS"],
                        tabs: [
                          ClientRequestsTab(),
                          // AdminRequests(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabbedLayout extends StatelessWidget {
  const TabbedLayout({
    Key? key,
    required this.tabLabel,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabLabel;
  final List<Widget> tabs;

  List<Widget> _buildTabsLabel() => tabLabel
      .map(
        (e) => Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            e,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: Var.defaultFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromRGBO(0, 0, 0, 0.1),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: AppColors.success,
              unselectedLabelColor: const Color(0x42000000),
              tabs: _buildTabsLabel(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: TabBarView(children: tabs)),
        ],
      ),
    );
  }
}

class ClientRequestsTab extends StatelessWidget {
  const ClientRequestsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, instance, child) => ListView.separated(
        padding: const EdgeInsets.all(5),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: instance.clientRequest.length,
        itemBuilder: (_, i) => RoundedTile(
          label: instance.clientRequest[i].client.name,
          avatar: Image.network(instance.clientRequest[i].client.image),
          icon: const Icon(ProjectBuilder.add),
          onPressed: () {
            updateUserDetails(
              userId: instance.clientRequest[i].client.userUid,
              role: Roles.client,
            ).then(
              (_) => instance
                .createClient(
                  client: instance.clientRequest[i].client,
                )
                .then((value) => FirebaseFirestore.instance
                    .collection("clientRequests")
                    .doc(instance.clientRequest[i].userId)
                    .delete()),
            );
          },
        ),
      )
    );
  }
}

Future<void> updateUserDetails(
    {required String userId, required Roles role}) async {
  final instance = FirebaseFirestore.instance
      .collection("users")
      .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel userModel, _) => userModel.toFirestore())
      .doc(userId);

  Roles? roles;//List<Roles> doc = [];
  instance.get().then((value) {
    roles = value.data()?.roles as Roles?;
    // roles.add(role);
  }).then((_) => {
    instance.update({'roles': roles.toString()})
  });
}

class AdminRequests extends StatelessWidget {
  const AdminRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, instance, child) => ListView.separated(
        padding: const EdgeInsets.all(5),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: instance.adminRequest.length,
        itemBuilder: (_, i) => RoundedTile(
          label: instance.adminRequest[i].user!.name,
          avatar: Image.network(
            instance.adminRequest[i].user!.profilePhoto ?? Var.noImageAvailable,
          ),
          icon: const Icon(ProjectBuilder.add),
          onPressed: () => updateUserDetails(
            userId: instance.adminRequest[i].user!.uid!,
            role: Roles.admin,
          ).then(
            (value) => FirebaseFirestore.instance
                .collection("adminRequests")
                .doc(instance.adminRequest[i].userId)
                .delete(),
          ),
        ),
      ),
    );
  }
}
