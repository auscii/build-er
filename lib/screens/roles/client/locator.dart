import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/location.dart';
import '../../../core/utils/global.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/icons/builder_icons.dart';
import '../../../styles/ui/colors.dart';
import '../../../core/models/client.dart';
import '../../../core/providers/appdata.dart';
import '../admin/add_products.dart';
import 'map.dart';

class Locator extends StatefulWidget {
  static const String id = Var.locator;
  const Locator({Key? key}) : super(key: key);
  @override
  State<Locator> createState() => _LocatorState();
}

class _LocatorState extends State<Locator> {

  @override
  void initState() {
    AppData.getUserResultIfVerified(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSM(),
        mapUtils(
          context: context,
          callback: () => _getLocation(context),
        ),
      ],
    );
  }

  void _getLocation(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false)
      .getUserLocation(context: context);
  }
}

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({Key? key}) : super(key: key);

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  Stream<QuerySnapshot<Client>> getClients() {
    return FirebaseFirestore.instance
        .collection('client')
        .withConverter(
          fromFirestore: Client.fromFirestore,
          toFirestore: (Client userModel, _) => userModel.toFirestore(),
        )
        .snapshots();
  }

  TextEditingController searchController = TextEditingController();

  late List<Client> data = [];

  late Stream<QuerySnapshot<Client>> instance;

  @override
  void initState() {
    super.initState();

    instance = FirebaseFirestore.instance
        .collection('client')
        .withConverter(
          fromFirestore: Client.fromFirestore,
          toFirestore: (Client userModel, _) => userModel.toFirestore(),
        )
        .snapshots();

    instance.listen((val) {
      setState(() {
        data = val.docs
            .map((QueryDocumentSnapshot<Client> clientSnapshot) =>
                clientSnapshot.data())
            .toList();
      });
    });
  }

  // This function is called whenever the text field changes
  void runFilter(String enteredKeyword) {
    List<Client> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = data;
    } else {
      results = data
              .where((client) => client.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList()
              .isEmpty
          ? data
          : data
              .where((client) => client.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      data = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          searchBuilder(),
          const SizedBox(height: 20),
          Expanded(
            child: data.isEmpty
                ? const Center(
                    child: Text(
                      "Fetching Clients",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(5),
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      return RoundedTile(
                        label: data[i].name,
                        avatar: Image.network(data[i].image),
                        icon: const Icon(ProjectBuilder.add),
                        onPressed: () {
                          Provider.of<AppData>(context, listen: false)
                              .createServiceRequest(ServiceRequest(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                clientId: data[i].userUid,
                                completed: false,
                              ))
                              .then((value) => {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop()
                                  });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  TextField searchBuilder() {
    return TextField(
      controller: searchController,
      onChanged: (value) => runFilter(value),
      style: const TextStyle(
        fontFamily: Var.defaultFont,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        prefixIcon: const Icon(ProjectBuilder.search_filled),
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.success,
            width: 2,
          ),
        ),
        hintText: Var.findNearbyContractors,
      ),
    );
  }
}

Positioned mapUtils(
    {required BuildContext context, required VoidCallback callback}) {
  return Positioned(
    bottom: 30,
    left: 10,
    right: 10,
    child: Center(
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Icon(Icons.chat),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const SearchOverlay());
                },
                style: const TextStyle(
                  fontFamily: Var.defaultFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(ProjectBuilder.search_filled),
                  fillColor: AppColors.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  hintText: Var.findNearbyContractors,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
