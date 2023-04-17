import 'dart:io';
import 'package:client/core/models/portfolio.dart';
import 'package:client/core/models/user.dart';
import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/core/utils/validator.dart';
import 'package:client/router/router.dart';
import 'package:client/screens/roles/admin/add_products.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class PortfolioScreen extends StatefulWidget {
  static const String id = Var.portfolio;
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _briefDetailsCompanyController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final FocusNode _briefDetailsCompanyFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _feedbackFocusNode = FocusNode();
  String? _previousProject;
  String? _companyLogo;
  int _ratings = 0;

  //TODO: - GET LISTS OF YOUR CREATED PORTFOLIOS ONLY.

  @override
  void initState() {
    AppData.getUserResultIfVerified(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
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
            child: 
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  GestureDetector(
                    child: 
                      Container(
                        height: 50,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0).withAlpha(100),
                                offset: const Offset(1, 1),
                                blurRadius: 8,
                                spreadRadius: 2
                            )
                          ],
                          color: Colors.blue
                        ),
                        child: const Text(
                          Var.addPortfolio,
                          style: TextStyle(
                            backgroundColor: Colors.transparent,
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white
                          ),
                        ),
                      ),
                      onTap: () => showDialog(
                      context: context,
                      builder: (context) =>  addPortfolio(),
                    ),
                  ),
                  // GestureDetector(
                  //   child: 
                  //     Container(
                  //       height: 50,
                  //       width: 200,
                  //       margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
                  //       alignment: Alignment.center,
                  //       decoration: BoxDecoration(
                  //         borderRadius: const BorderRadius.all(Radius.circular(25)),
                  //         boxShadow: <BoxShadow>[
                  //           BoxShadow(
                  //               color: const Color.fromARGB(255, 0, 0, 0).withAlpha(100),
                  //               offset: const Offset(1, 1),
                  //               blurRadius: 8,
                  //               spreadRadius: 2
                  //           )
                  //         ],
                  //         color: Colors.green
                  //       ),
                  //       child: const Text(
                  //         Var.refresh,
                  //         style: TextStyle(
                  //           backgroundColor: Colors.transparent,
                  //           fontFamily: Var.defaultFont,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 19,
                  //           color: Colors.white
                  //         ),
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       Loader.show(context, 0);
                  //       AppData.clearPortfolioLists();
                  //       Future.delayed(const Duration(milliseconds: 3000), () {
                  //         Loader.stop();
                  //         setState(() {
                  //           AppData.getPortfolioLists();
                  //         });
                  //       });
                  //     },
                  // ),
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
                ]
              ),
          ),
        ),
      )
    );
  }

  Widget addPortfolio() {
    return AppDialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Var.addPortfolio,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 35),
              textArea(
                _briefDetailsCompanyController,
                _briefDetailsCompanyFocusNode,
                Var.briefDetails
              ),
              const SizedBox(height: 25),
              textArea(
                _companyNameController,
                _companyNameFocusNode,
                Var.companyName
              ),
              const SizedBox(height: 25),
              companyLogo(
                context,
                _companyLogo ?? Var.noImageAvailable,
                Var.companyLogo
              ),
              const SizedBox(height: 25),
              previousProject(
                context,
                _previousProject ?? Var.noImageAvailable,
                Var.previousCompany
              ),
              // const SizedBox(height: 25),
              // textArea(
              //   _feedbackController,
              //   _feedbackFocusNode,
              //   Var.feedback
              // ),
              // const SizedBox(height: 35),
              // ratings(3),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<AppData>(context, listen: false)
                    .createPortfolio(
                      portfolio: Portfolio(
                        id: "${Var.portfolioCode}${Var.charRandomizer()}",
                        briefDetails: _briefDetailsCompanyController.text,
                        companyName: _companyNameController.text,
                        companyLogo: _companyLogo ?? Var.noImageAvailable,
                        previousProject: _previousProject ?? Var.noImageAvailable,
                        ratings: 0,
                        feedback: Var.na,
                        createdBy: FirebaseAuth.instance.currentUser!.uid,
                        dateTimeCreated: Timestamp.now()
                      ),
                    ).then(
                      (value) {
                        clearInputs(false);
                        GlobalNavigator.goBack();
                        // NavigationMenu.activeIndex = 1;
                        // GlobalNavigator.navigateToScreen(const NavigationMenu());
                      },
                    );
                  } else {
                    Toast.show(Var.unableSave);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      Var.submit,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget setPortflioImages(
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
              margin: const EdgeInsets.only(left: 0),
              child: 
                Text(
                  "${Var.companyName.toCapitalized()}: $companyName",
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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
                  // const SizedBox(height: 25),
                  // const Divider(color: Colors.black, thickness: 1, height: 1),
                  // const SizedBox(height: 25),
                  // const Text(
                  //   Var.feedback,
                  //   style: TextStyle(
                  //     fontFamily: Var.defaultFont,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // Text(
                  //   feedback,
                  //   style: const TextStyle(
                  //     fontFamily: Var.defaultFont,
                  //     fontWeight: FontWeight.normal,
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // const SizedBox(height: 25),
                  // const Divider(color: Colors.black, thickness: 1, height: 1),
                  // const SizedBox(height: 25),
                  // ratings(rating),
                  // const SizedBox(height: 25),
                  // const Divider(color: Colors.black, thickness: 1, height: 1),
                  // const SizedBox(height: 25),
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

  textArea(
    TextEditingController fieldController,
    FocusNode fieldNode,
    String inputName
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: Var.defaultFont,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: fieldController,
          focusNode: fieldNode,
          validator: (value) => InputValidator.validateName(
            name: value!,
            label: inputName
          ),
          minLines: 4,
          maxLines: 5,
          style: const TextStyle(
            fontFamily: Var.defaultFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Colors.black
          ),
          decoration: InputDecoration(
            hintText: Var.enter + inputName,
            filled: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 5, 20),
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Row companyLogo(
    BuildContext context,
    String imagePath,
    String imageName
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              imageName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.bgDark,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.149),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => imageUpload(context, imageName),
                child: 
                  Image.network(
                    _companyLogo ?? Var.noImageAvailable,
                    errorBuilder: (_, __, ___) {
                      return const FlutterLogo(size: 78);
                    },
                  ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Row previousProject(
    BuildContext context,
    String imagePath,
    String imageName
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              imageName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.bgDark,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.149),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => imageUpload(context, imageName),
                child: 
                  Image.network(
                    _previousProject ?? Var.noImageAvailable,
                    errorBuilder: (_, __, ___) {
                      return const FlutterLogo(size: 78);
                    },
                  ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  imageUpload(
    BuildContext context,
    String activeUpload
  ) async {
      PickedFile? image;
      // ignore: use_build_context_synchronously
      FocusScope.of(context).requestFocus(FocusNode());
      var firebaseStorage = FirebaseStorage.instance;
      var imagePicker = ImagePicker();
      await [
        Permission.camera,
        Permission.storage,
        Permission.photos,
        Permission.manageExternalStorage,
      ].request();
      image = await imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image?.path ?? Var.noImageAvailable);
      if (image != null) {
        firebaseStorage.ref()
          .child("${Var.imagesRef}${Var.portfolio}/${Var.charRandomizer()}${Var.jpeg}")
          .putFile(file)
          .snapshotEvents.listen((taskSnapshot) async {
            switch (taskSnapshot.state) {
              case TaskState.running:
                final progress =
                    100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                Toast.show("${Var.uploading} $progress%");
                // Loader.show(context, 0);
                break;
              case TaskState.success:
                Toast.show(Var.uploadingCompleted);
                String downloadURL = await taskSnapshot.ref.getDownloadURL();
                imageCache.clear();
                imageCache.clearLiveImages();
                if (Var.companyLogo == activeUpload) {
                  setState(() => _companyLogo = downloadURL);
                } else {
                  setState(() => _previousProject = downloadURL);
                }
                // Loader.stop();
                break;
              case TaskState.paused:
                Toast.show(Var.uploadingPaused);
                // Loader.stop();
                break;
              case TaskState.canceled:
                Toast.show(Var.uploadingCanceled);
                // Loader.stop();
                break;
              case TaskState.error:
                Toast.show(Var.uploadingError);
                // Loader.stop();
                break;
            }
          });
      } else {
        Toast.show(Var.noImageReceived);
      }
  }

  clearInputs(bool shouldDisposeNow) {
    if (shouldDisposeNow) {
      _briefDetailsCompanyController.dispose();
      _companyNameController.dispose();
      _feedbackController.dispose();
      _briefDetailsCompanyFocusNode.dispose();
      _companyNameFocusNode.dispose();
      _feedbackFocusNode.dispose();
      return;
    }
    _briefDetailsCompanyController.clear();
    _companyNameController.clear();
    _feedbackController.clear();
    _companyLogo = Var.noImageAvailable;
    _previousProject = Var.noImageAvailable;
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
            _ratings = rating.round();
          },
        )
      ],
    );
  }

  Future<void> _pullRefresh() async {
    Loader.show(context, 0);
    AppData.clearPortfolioLists();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Loader.stop();
      setState(() {
        AppData.getPortfolioLists();
      });
    });
  }

}