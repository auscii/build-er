import 'dart:async';
import 'package:client/screens/roles/client/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  //TODO: - TO UPDATE GET LISTS OF VERIFIED CONTRACTORS ONLY THEN GET THE LISTS OF ALL PORTFOLIOS

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
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            searchBuilder(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.black,
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  children: Var.portfolioLists.map((portf) {
                    return setPortflioImages(
                      context,
                      portf.briefDetails,
                      portf.companyLogo,
                      portf.companyName,
                      portf.feedback,
                      portf.previousProject,
                      portf.ratings
                    );
                  }).toList(),
                ),
              ),
            )
            // Expanded(
            //   child: data.isEmpty
            //   ? const Center(
            //       child: Text(
            //         "Fetching Clients",
            //         style: TextStyle(
            //           fontFamily: "SF Pro Rounded",
            //           fontWeight: FontWeight.w500,
            //           color: AppColors.textPrimary,
            //           fontSize: 16,
            //         ),
            //       ),
            //     )
            //   : ListView.separated(
            //       padding: const EdgeInsets.all(5),
            //       separatorBuilder: (_, __) => const SizedBox(height: 15),
            //       itemCount: data.length,
            //       itemBuilder: (_, i) {
            //         return RoundedTile(
            //           label: data[i].name,
            //           avatar: Image.network(data[i].image),
            //           icon: const Icon(ProjectBuilder.add),
            //           onPressed: () {
            //             Provider.of<AppData>(context, listen: false)
            //                 .createServiceRequest(ServiceRequest(
            //                   userId: FirebaseAuth.instance.currentUser!.uid,
            //                   clientId: data[i].userUid,
            //                   completed: false,
            //                 ))
            //                 .then((value) => {
            //                       Navigator.of(context, rootNavigator: true)
            //                           .pop()
            //                     });
            //           },
            //         );
            //       },
            //     ),
            // ),
          ],
        ),
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

Widget setPortflioImages(
  BuildContext context,
  String briefDetails,
  String companyLogo,
  String companyName,
  String feedback,
  String previousProject,
  int rating
) {
  return InkWell(
    onTap: () => showDialog(
      context: context,
      builder: (context) => viewPortfolio(
      briefDetails,
      companyLogo,
      companyName,
      feedback,
      previousProject,
      rating
    )),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10))),
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: 
              Text(
                "${Var.companyName}: $companyName",
                style: const TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
          ),
          const SizedBox(height: 50),
          Container(
            margin: EdgeInsets.zero,
            width: 450,
            height: 220,
            child: Image.network(
              companyLogo,
              width: 250,
              height: 250,
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    ),
  );
}
  
Widget viewPortfolio(
  String briefDetails,
  String companyLogo,
  String companyName,
  String feedback,
  String previousProject,
  int rating
) {
  return AppDialog(
    child: SingleChildScrollView(
      child: 
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  Var.companyName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  companyName,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(color: Colors.black, thickness: 1, height: 1),
                const SizedBox(height: 25),
                const Text(
                  Var.companyLogo,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  width: 350,
                  height: 200,
                  child: Image.network(
                    companyLogo,
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
                  Var.previousCompany,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  width: 350,
                  height: 200,
                  child: Image.network(
                    previousProject,
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
                  Var.briefDetails,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  briefDetails,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(color: Colors.black, thickness: 1, height: 1),
                const SizedBox(height: 25),
                const Text(
                  Var.feedback,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  feedback,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(color: Colors.black, thickness: 1, height: 1),
                const SizedBox(height: 25),
                ratings(rating),
                const SizedBox(height: 25),
                const Divider(color: Colors.black, thickness: 1, height: 1),
                const SizedBox(height: 25),
                /*
                Container(
                  color: Colors.transparent,
                  child: GestureDetector(
                    child: ListTile(
                      leading: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Container(
                          height: 250,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                image: NetworkImage(companyLogo),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(width: 2, color: Colors.white)
                          ),
                        ),
                      ),
                      title: 
                        Text(
                          "COMPANY NAME: $companyName",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      subtitle: 
                        Text(
                          "BRIEF DETAILS OF THE COMPANY: $briefDetails",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ),
                  )
                )
                */
              ]
            )
          ]
        ),
    )
  );
}

Widget ratings(int? ratingValue) {
  return Column(
    children: [
      const Text(
        Var.ratings,
        style: TextStyle(
          fontFamily: Var.defaultFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),
      ),
      RatingBar.builder(
        initialRating: ratingValue != null ? ratingValue.toDouble() : 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          // _ratings = rating.round();
        },
      )
    ],
  );
}

Positioned mapUtils(
    {required BuildContext context, required VoidCallback callback}) {
  print("from top of mapUtils");
  return Positioned(
    bottom: 30,
    left: 10,
    right: 10,
    child: Center(
      // child: ConstrainedBox(
      //   constraints: pageConstraints,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // CHAT FAB
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.black,
            //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //     elevation: 0,
            //   ),
            //   child: const Icon(Icons.chat),
            // ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onTap: () {
                  print("find nearby contractors...");
                  FocusManager.instance.primaryFocus?.unfocus();
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
      // ),
    ),
  );
}
