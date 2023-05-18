import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/modal.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/screens/roles/admin/product_orders.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/user.dart';
import '../../../styles/icons/builder_icons.dart';
import '../../../core/providers/appdata.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/ui/colors.dart';
import 'add_products.dart';

class AdminHome extends StatefulWidget {
  static const String id = Var.admin;
  const AdminHome({
    Key? key,
  }) : super(key: key);
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  @override
  void initState() {
    super.initState();
  }

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
                  fontWeight: FontWeight.normal,
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
      // minimum: const EdgeInsets.only(top: 20, left: 36, right: 36),
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                  flex: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        Var.products,
                        style: TextStyle(
                          fontFamily: Var.defaultFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAddItem(
                            context: context,
                            label: Var.addProduct,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const AddProduct(
                                admin: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          _buildAddItem(
                            context: context,
                            label: "PRODUCT ORDERS",
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const AdminProductOrders(
                                admin: true,
                              ),
                            ),
                            // onPressed: ()
                            //   => Modal.adminProductOrderApprovalPrompt(context),
                          ),
                        ],
                      ),
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
                        "USERS VERIFICATION",
                        style: TextStyle(
                          fontFamily: Var.defaultFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: TabbedLayout(
                          tabLabel: [
                            Var.contractorRequests,
                            Var.clientRequests
                          ],
                          tabs: [
                            ContractorRequestsTab(),
                            ClientRequestsTab(),
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
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: 
          GestureDetector(
            child:
              Text(
                e,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ),
      ),
    ).toList();

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
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0x42000000),
              tabs: _buildTabsLabel(),
              onTap: (i) {
                var selectedTab = tabs[i];
                showDialog(
                  context: context,
                  builder: (context) 
                    => viewUserNeedToVerify(context, "$selectedTab")
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: TabBarView(children: tabs)),
        ],
      ),
    );
  }

  Widget viewUserNeedToVerify(
    BuildContext context,
    String userType
  ) {
    List<UserModel> filteredUsers = [];
    userType == Var.contractorRequestTab ?
      filteredUsers = Var.filteredContractorUsers :
      filteredUsers = Var.filteredClientUsers;
    return AppDialog(
      child: SingleChildScrollView(
        child: 
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(
                userType == Var.contractorRequestTab ? 
                Var.contractor.toUpperCase() + Var.s + Var.user :
                Var.client.toUpperCase() + Var.s + Var.user,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: filteredUsers.map((user) {
                  String userStatus
                    = user.isUserVerified == Var.userPendingForVerification ?
                    Var.userNotVerified : Var.verifiedUser;
                  return Container(
                    color: const Color(0xFF979797).withOpacity(0.1),
                    child:
                      GestureDetector(
                        onTap: () {
                          if (user.isUserVerified == Var.adminApprovedUserVerification) {
                            Toast.show(Var.verifiedUser, null);
                            return;
                          }
                          Modal.userApproval(
                            context,
                            user.userValidID ?? Var.noImageAvailable,
                            user.name ?? Var.na,
                            user.uid ?? Var.na,
                            user.phone ?? Var.na,
                            user.email ?? Var.na,
                            user.address?.name ?? Var.na
                          );
                          // Modal.promptUserVerify(
                          //   context, Var.verifyThisUserMsg 
                          //   + (user.name ?? Var.e) + Var.q,
                          //   Var.yes, Var.no, user.uid ?? Var.e
                          // );
                        },
                        child: ListTile(
                          // leading: Transform.translate(
                          //   offset: const Offset(0, 5),
                          //   child: Container(
                          //     height: 250,
                          //     width: 60,
                          //     decoration: BoxDecoration(
                          //         color: Colors.black,
                          //         // image: DecorationImage(
                          //         //   image: NetworkImage(Var.noImageAvailable),
                          //         //   fit: BoxFit.cover,
                          //         // ),
                          //         border: Border.all(width: 2, color: Colors.white)
                          //     ),
                          //   ),
                          // ),Status: $userStatus
                          title: Text(
                            "Name: ${user.name!}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            "Status: $userStatus",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: (user.isUserVerified == Var.userPendingForVerification) ?
                                Colors.red : Colors.green,
                              fontSize: 16,
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // trailing: Text(
                          //   "User ID: ${user.uid}",
                          //   textAlign: TextAlign.left,
                          //   style: const TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 15,
                          //     fontFamily: Var.defaultFont,
                          //     fontWeight: FontWeight.normal,
                          //   ),
                          // ),
                        ),
                      )
                  );
                }).toList(),
              )
            ]
          ),
      )
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
            // updateUserDetails(
            //   userId: instance.clientRequest[i].client.userUid,
            //   role: Roles.client,
            // ).then(
            //   (_) => instance
            //     .createClient(
            //       client: instance.clientRequest[i].client,
            //     )
            //     .then((value) => FirebaseFirestore.instance
            //         .collection("clientRequests")
            //         .doc(instance.clientRequest[i].userId)
            //         .delete()),
            // ); 
          },
        ),
      )
    );
  }
}

class ContractorRequestsTab extends StatelessWidget {
  const ContractorRequestsTab({Key? key}) : super(key: key);
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
          onPressed: () {},
        ),
      )
    );
  }
}