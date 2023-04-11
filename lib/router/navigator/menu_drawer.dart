import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../router.dart';
import 'navigation_menu.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});
  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  Map userDetails = {};
  @override
  void initState() {
    super.initState();
  }

  getUserDetails() async {}

  @override
  Widget build(BuildContext context) {
    final List clientMenu = [
      {
        'icon': Icons.home,
        'title': Var.home,
      },
      {
        'icon': Icons.person,
        'title': Var.profile,
      },
      {
        'icon': Icons.info,
        'title': Var.about,
      },
      {
        'icon': Icons.lock,
        'title': Var.logout,
      }
    ];

    navigateTo(title) {
      if (title == Var.home) {
        NavigationMenu.activeIndex = 0;
        GlobalNavigator.pushReplaceNav(context, 0);
      } else if (title == Var.profile) {
        NavigationMenu.activeIndex = 3;
        GlobalNavigator.pushReplaceNav(context, 3);
      } else if (title == Var.about) {
        NavigationMenu.activeIndex = 4;
        GlobalNavigator.pushReplaceNav(context, 4);
      } else if (title == Var.logout) {
        Provider.of<UserProvider>(
          context, 
          listen: false
        ).signOut(context);
      }
    }

    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 70,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                            image: AssetImage(Var.userPlaceholder),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(width: 2, color: Colors.white)
                      ),
                      height: 60,
                      width: 60,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          Var.welcome,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          "${Provider.of<UserProvider>(context).user.name}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (var i in clientMenu) 
              ListTile(
                minLeadingWidth: 20,
                leading: Icon(
                  i['icon'],
                  size: 22,
                  color: Colors.white,
                ),
                title: Text(
                  i['title'],
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                onTap: () {
                  navigateTo(i['title']);
                },
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.zero,
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Column(
                    children: <Widget>[
                      const Divider(color: Colors.white),
                      ListTile(
                        onTap: () {},
                        title: 
                          const Text(
                            Var.faq,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                      ),
                      ListTile(
                        onTap: () {},
                        title: 
                         const Text(
                            Var.privacyPolicy,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                      ),
                      const SizedBox(height: 50),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              SizedBox(width: 15),
                              Text(
                                Var.copyright,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  )
                )
              ),
          ],
        ),
      ),
    );
  }

}
