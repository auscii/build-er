import 'package:client/core/models/messages.dart';
import 'package:client/core/models/notifications.dart';
import 'package:client/core/models/user.dart';
import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/modal.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/navigator/menu_drawer.dart';
import 'package:client/router/routes.dart';
import 'package:client/screens/roles/admin/admin_products.dart';
import 'package:client/screens/roles/admin/home.dart';
import 'package:client/screens/roles/admin/users_lists.dart';
import 'package:client/screens/roles/client/components/product_checkout.dart';
import 'package:client/screens/roles/client/components/product_details.dart';
import 'package:client/screens/roles/client/components/product_order_details.dart';
import 'package:client/screens/roles/client/ecommerce.dart';
import 'package:client/screens/roles/client/locator.dart';
import 'package:client/screens/roles/contractor/home.dart';
import 'package:client/screens/roles/contractor/portfolio.dart';
import 'package:client/screens/shared/about.dart';
import 'package:client/screens/shared/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/utils/global.dart';
import '../../screens/roles/client/home.dart';
import '../router.dart';
import '../../styles/icons/builder_icons.dart';
import '../../../styles/ui/colors.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:ymchat_flutter/ymchat_flutter.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480, maxHeight: 1000, minHeight: 350);

class NavigationMenu extends StatefulWidget {
  final String routeToNavigate;
  static int activeIndex = 0;
  static const String id = "roles_manager";
  const NavigationMenu({
    this.routeToNavigate = PageRouter.initialRoute,
    Key? key,
    int? activeIndex,
  }) : super(key: key);
  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  static CupertinoTabView? returnValue;
  static TextEditingController chatControllerField = new TextEditingController();

  @override
  void initState() {
    initilizeChatbot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgDark,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          Var.builder,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: Var.defaultFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Notifications>(
            onSelected:(value) {
              Toast.show(
                value.toUser == Var.currentUserID ?
                value.actionMessage : 
                Var.noAvailableNotifs,
                null
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white
            ),
            itemBuilder: (BuildContext context) {
              return Var.notifLists.where((n) => n.toUser == Var.currentUserID)
                .map((Notifications notifs) {
                return PopupMenuItem<Notifications>(
                  value: notifs,
                  child: Text(
                    notifs.actionMessage
                  )
                  // child: Text(
                  //   notifs.toUser == Var.currentUserID ?
                  //   notifs.actionMessage : 
                  //   Var.noAvailableNotifs
                  // ),
                );
              }).toList();
            },
          ),
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            padding: const EdgeInsets.only(left: 16, right: 16),
            icon: const Icon( 
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
            alignment: Alignment.centerLeft,
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      // Var.activeUserRole != Var.admin ?
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 640),
        child: Var.activeUserRole == Var.client ? Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Var.productCarts.clear();
                  AppData.getProductCarts();
                  Loader.show(context, 0);
                  Future.delayed(const Duration(milliseconds: 5000), () {
                    Loader.stop();
                    Modal.productCart(context);
                  });
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("PRODUCT CART"),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                // onPressed: () => YmChat.startChatbot(),
                onPressed: () => selectChatUser(context), //Modal.privateChat(context, ""),
                icon: const Icon(Icons.chat),
                label: const Text("CHAT"),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ) : 
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            onPressed: () => selectChatUser(context),
            icon: const Icon(Icons.chat),
            label: const Text("CHAT"),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          onTap: (value) {
            setState(() => NavigationMenu.activeIndex = value);
            if (value == 0) {
              NavigationMenu.activeIndex = 0;
              GlobalNavigator.replaceScreen(const NavigationMenu(activeIndex: 0));
            } else if (value == 1) {
              NavigationMenu.activeIndex = 1;
            } else if (value == 2) {
              NavigationMenu.activeIndex = 2;
            }
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          backgroundColor: Colors.black,
          height: 55,
          items: Var.activeUserRole == Var.client ?
          const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe318,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.home
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe59c,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.ecommerce,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe2dc,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.capsContractor,
            ),
          ] :
          Var.activeUserRole == Var.contractor ?
          const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe318,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.home
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xf0541,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.portfolio,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xf0891,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.profile,
            ),
          ] :
          <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xe318,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.home
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                IconData(
                  0xe61e,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.users.toUpperCase(),
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                IconData(
                  0xec90,
                  fontFamily: Var.materialIcons
                ),
              ),
              label: Var.products,
            ),
          ],
        ),
        tabBuilder: (context, index) {
          CupertinoTabView? home;
          index = NavigationMenu.activeIndex;
          home =  CupertinoTabView(builder: (context) => const ClientHome());
          // home = 
          // Var.activeUserRole == Var.client ? 
          // CupertinoTabView(builder: (context) => const ClientHome()) :
          // Var.activeUserRole == Var.contractor ?
          // CupertinoTabView(builder: (context) => const ContractorHome()) :
          // CupertinoTabView(builder: (context) => const AdminHome());

          if (Var.activeUserRole == Var.client) {
            home =  CupertinoTabView(builder: (context) => const ClientHome());
          } else if (Var.activeUserRole == Var.contractor) {
            home =  CupertinoTabView(builder: (context) => const ContractorHome());
          } else if (Var.activeUserRole == Var.admin) {
            home =  CupertinoTabView(builder: (context) => const AdminHome());
          } else {
            // GlobalNavigator.router.currentState!.pushReplacementNamed(AuthRoutes.onboarding);
            // GlobalNavigator.push(context, const Onboarding());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyPage()));
              GlobalNavigator.router.currentState!.pushReplacementNamed(AuthRoutes.onboarding);
            });
          }
          
          switch (index) {
            case 0:
              returnValue = home;
              break;
            case 1:
              returnValue
              = Var.activeUserRole == Var.client ? 
                CupertinoTabView(builder: (context) => const Ecommerce()) :
                Var.activeUserRole == Var.contractor ?
                CupertinoTabView(builder: (context) => const PortfolioScreen()) :
                CupertinoTabView(builder: (context) => const UserLists());
              // returnValue = CupertinoTabView(builder: (context) => const Ecommerce());
              break;
            case 2:
              returnValue
              = Var.activeUserRole == Var.client ? 
                CupertinoTabView(builder: (context) => const Locator()) :
                Var.activeUserRole == Var.contractor ?
                CupertinoTabView(builder: (context) => ProfilePage()) :
                CupertinoTabView(builder: (context) => const AdminProducts());
              // returnValue = CupertinoTabView(builder: (context) => const Locator());
              break;
            case 3:
              returnValue = CupertinoTabView(builder: (context) => ProfilePage());
              break;
            case 4:
              returnValue = CupertinoTabView(builder: (context) => const AboutPage());
              break;
            case 5:
              returnValue = CupertinoTabView(builder: (context) => const ProductDetails());
              break;
            case 6:
              returnValue = CupertinoTabView(builder: (context) => const AdminProducts());
              break;
            case 7:
              returnValue = CupertinoTabView(builder: (context) => const ProductCheckout());
              break;
            case 8:
              returnValue = CupertinoTabView(builder: (context) => const ProductOrderDetails());
              break;
          }
          return returnValue ?? home;
        },
      )
    );
  }

  Widget _navItem({
    IconData? icon = ProjectBuilder.info,
    String label = Var.na,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        textStyle: const TextStyle(
          fontFamily: Var.defaultFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      label: Text(label),
    );
  }

  void initilizeChatbot() {
    // Initializing chatbot id to work with in the SDK
    YmChat.setBotId("x1625119673009");

    // Adding payload to communicate with chatbot
    YmChat.setPayload({"integration": "Flutter"});

    // Enabling UI close button
    YmChat.showCloseButton(true);

    // Enabling voice input
    YmChat.setEnableSpeech(true);

    // using new widget
    YmChat.setVersion(2);

    // Setting statusbar color
    YmChat.setStatusBarColor("#FFFFFF");

    // Setting close button color
    YmChat.setCloseButtonColor("#FFFFFF");

    // Using lite version
    YmChat.useLiteVersion(true);

    // Listening to bot events
    EventChannel _ymEventChannel = const EventChannel("YMChatEvent");
    print("ymChat name ->${_ymEventChannel.name}");
    _ymEventChannel.receiveBroadcastStream().listen((event) {
      Map ymEvent = event;
      print("ymChat message ->${ymEvent['data']}");
      log("${ymEvent['code']} : ${ymEvent['data']}");
    });

    // Listening to close bot events
    EventChannel _ymCloseEventChannel = const EventChannel("YMBotCloseEvent");
    _ymCloseEventChannel.receiveBroadcastStream().listen((event) {
      bool ymCloseEvent = event;
      log(event.toString());
    });
  }
  
  Future<dynamic> selectChatUser(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: 
              Text(
                "Please select user to Chat",
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.black
                ),
              )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Container(
              //   margin: EdgeInsets.zero,
              //   child: const Text(
              //     "Users:",
              //     textAlign: TextAlign.justify,
              //     style: TextStyle(
              //       fontFamily: Var.defaultFont,
              //       fontWeight: FontWeight.normal,
              //       fontSize: 19,
              //       color: Colors.black
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              Container(
                height: 75,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 28),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255).withAlpha(100),
                      offset: const Offset(1, 1),
                      blurRadius: 8,
                      spreadRadius: 2
                    )
                  ],
                  color: Colors.black
                ),
                child: Expanded(
                  child: DropdownButton<UserModel>(
                    focusColor: Colors.black,
                    dropdownColor: Colors.black,
                    value: Var.allUsers.where(
                      (u) => u.isUserVerified == Var.adminApprovedUserVerification &&
                      u.uid != Var.currentUserID
                    ).first,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_sharp,
                      color: Colors.white
                    ),
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (UserModel? value) {
                      privateChat(context, value!.name ?? Var.e, value.uid ?? Var.e);
                    },
                    items: Var.allUsers.where(
                      (u) => u.isUserVerified == Var.adminApprovedUserVerification &&
                      u.uid != Var.currentUserID
                    ).map<DropdownMenuItem<UserModel>>((UserModel value) {
                      return DropdownMenuItem<UserModel>(
                        value: value,
                        child: Text(value.name ?? Var.na),
                      );
                    }).toList(),
                  )
                ),
                // const Text(
                //   Var.ok,
                //   style: TextStyle(
                //     backgroundColor: AppColors.primary,
                //     fontFamily: Var.defaultFont,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 19,
                //     color: Colors.white
                //   ),
                // ),
              ),
            ],
          ),
        );
      });
  }
  
  Future<dynamic> privateChat(
    BuildContext context, 
    String chatName,
    String chatUserID
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Private message with - $chatName",
              style: const TextStyle(
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Colors.black
              ),
            )
          ),
          content: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 2500, //MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            if (value.isEmpty) {
                              Toast.show(Var.requiredField, null);
                              return;
                            }
                            chatControllerField.clear();
                            Loader.show(context, 0);
                            AppData.sendMessage(
                              mess: Messages(
                                id: "${Var.msCode}${Var.charRandomizer()}",
                                message: value,
                                receiverUserID: chatUserID,
                                createdAt: Var.now.toString(),
                                createdBy: Var.currentUserID,
                                status: 1
                              )
                            );
                            setState(() {
                              Var.messageLists.clear();
                            });
                            Future.delayed(const Duration(milliseconds: 5000), () {
                              Loader.stop();
                              GlobalNavigator.doubleGoBack();
                              privateChat(
                                context, 
                                chatName,
                                chatUserID
                              );
                              Toast.show(Var.messageSuccess, null);
                            });
                          },
                          controller: chatControllerField,
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.fromLTRB(30, 17, 0, 17),
                            fillColor: AppColors.input,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 0.0
                              ),
                            ),
                            hintText: "Enter chat message...",
                            helperStyle: const TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 10,
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.zero,
                      height: 2500,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: Var.messageLists.where(
                          (m) => m.createdBy == Var.currentUserID &&
                          m.receiverUserID == chatUserID
                          ).map((value) {
                            return Container(
                              padding: value.createdBy == Var.currentUserID ? const EdgeInsets.only(
                                right: 100,
                                left: 14,
                                top: 10,
                                bottom: 10
                              ) : const EdgeInsets.only(
                                left: 100, 
                                right: 14, 
                                top: 10,
                                bottom: 10
                              ),
                              child: Align(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (value.createdBy == Var.currentUserID ?
                                      Colors.blue[200] :
                                      Colors.grey.shade200
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Me: ${value.message}",
                                          textAlign: TextAlign.left
                                        ),
                                      ],
                                    ),
                                  )
                                )
                              ),
                            );
                        }).toList(),
                      ),
                      /*
                      child: ListView.builder(
                        itemCount: Var.messageLists.where(
                          (m) => //m.receiverUserID == chatUserID &&
                          m.createdBy == Var.currentUserID
                        ).length,
                        itemCount: Var.messageLists.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Container(
                            padding: const EdgeInsets.only(
                              right: 14,
                              left: 14, 
                              top: 10,
                              bottom: 10
                            ),
                            // padding: Var.messageLists[i].createdBy == Var.currentUserID ?
                            // const EdgeInsets.only(
                            //   right: 100,
                            //   left: 14, 
                            //   top: 10,
                            //   bottom: 10
                            // ) : const EdgeInsets.only(
                            //   left: 100, 
                            //   right: 14, 
                            //   top: 10,
                            //   bottom: 10
                            // ),
                            child: Align(
                              // alignment: (Var.messageLists[index].type == "APPROVAL"?Alignment.topLeft:Alignment.topRight),
                              child: Container( // Var.messageLists[i].receiverUserID == chatUserID ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (Var.messageLists[i].createdBy == Var.currentUserID ?
                                    Colors.blue[200] :
                                    Colors.grey.shade200
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  Var.messageLists[i].message,
                                  style: const TextStyle(fontSize: 15)
                                ),
                              )
                              //: const SizedBox(),
                            ),
                          );
                        },
                      ),
                      */
                    ),
                  ],
                ),
              ),
            )
          )
        );
      });
  }

}