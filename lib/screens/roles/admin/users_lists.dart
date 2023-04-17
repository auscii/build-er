import 'dart:io';
import 'package:client/core/models/address.dart';
import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/core/utils/validator.dart';
import 'package:client/router/router.dart';
import 'package:client/screens/roles/admin/add_products.dart';
import 'package:client/screens/roles/client/components/product_description.dart';
import 'package:client/screens/roles/client/components/product_images.dart';
import 'package:client/styles/icons/builder_icons.dart';
import 'package:client/styles/theme/theme.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:client/core/models/products.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/loader.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);


class UserLists extends StatefulWidget {
  static const id = Var.userLists;
  const UserLists({
    Key? key,
  }) : super(key: key);
  @override
  State<UserLists> createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _productNameController = TextEditingController();
  // final TextEditingController _productImageController = TextEditingController();
  // final TextEditingController _productDescriptionController = TextEditingController();
  // final TextEditingController _productPriceController = TextEditingController();
  // final FocusNode _productNameFocusNode = FocusNode();
  // final FocusNode _productImageFocusNode = FocusNode();
  // final FocusNode _productDescriptionFocusNode = FocusNode();
  // final FocusNode _productPriceFocusNode = FocusNode();
  // static String productImagePath = Var.noImageAvailable;
  // static String _productCategoryValue = Var.na;
  
  @override
  void initState() {
    setState(() => Var.appTitle = Var.viewUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
          child: 
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  children: Var.usersLists.map((user){
                    return Container(
                      // height: 90,
                      // margin: const EdgeInsets.all(5),
                      // padding: const EdgeInsets.all(5),
                      // color: AppColors.bg,
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => viewUsers(
                            user.uid ?? "",
                            user.name ?? "",
                            user.email ?? "",
                            user.phone ?? "",
                            user.profilePhoto ?? "",
                            user.description ?? "",
                            user.password ?? "",
                            user.address!,
                            user.roles ?? "",
                            user.userCompanyName ?? "",
                            user.userPermit ?? "",
                            user.userLicense ?? "",
                            user.userDTI ?? "",
                            user.userSec ?? "",
                            user.userValidID ?? "",
                          ),
                        ),
                        child: ListTile(
                          // leading: Transform.translate(
                          //   offset: const Offset(0, 5),
                          //   child: Container(
                          //     height: 250,
                          //     width: 60,
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         image: DecorationImage(
                          //           image: NetworkImage(prod.image),
                          //           fit: BoxFit.cover,
                          //         ),
                          //         border: Border.all(width: 2, color: Colors.white)
                          //     ),
                          //   ),
                          // ),
                          title: 
                            Text(
                              "Name: ${user.name!}",
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
                              "User ID: ${user.uid}",
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
                    );
                  }).toList(),
                )
              ]
            ),
          ),
      )
    );
  }
  
  Widget viewUsers(
    String id,
    String name,
    String email,
    String phone,
    String profilePhoto,
    String description,
    String password,
    Address address,
    String roles,
    String userCompanyName,
    String userPermit,
    String userLicense,
    String userDTI,
    String userSec,
    String userValidID,
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
                  Container(
                    color: const Color(0xFF979797).withOpacity(0.1),
                    child: GestureDetector(
                      // onTap: () => showDialog(
                      //   context: context,
                      //   builder: (context) => viewProduct(
                      //     prod.id,
                      //     prod.title,
                      //     prod.image,
                      //     prod.category,
                      //     prod.description,
                      //     prod.price
                      //   ),
                      // ),
                      child: ListTile(
                        // leading: Transform.translate(
                        //   offset: const Offset(0, 5),
                        //   child: Container(
                        //     height: 250,
                        //     width: 60,
                        //     decoration: BoxDecoration(
                        //         color: Colors.black,
                        //         image: DecorationImage(
                        //           image: NetworkImage(prod.image),
                        //           fit: BoxFit.cover,
                        //         ),
                        //         border: Border.all(width: 2, color: Colors.white)
                        //     ),
                        //   ),
                        // ),
                        title: 
                          Text(
                            "NAME: $name",
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
                            "USER ID: $id",
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
                ]
              )
            ]
          ),
      )
    );
  }
    // return AppDialog(
    //   child: SingleChildScrollView(
    //     child: Form(
    //       key: _formKey,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text(
    //             Var.viewUser,
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 30,
    //               fontFamily: Var.defaultFont,
    //               fontWeight: FontWeight.w700,
    //             ),
    //           ),
    //           const SizedBox(height: 35),
    //           productImage(context, img),
    //           const SizedBox(height: 25),
    //           productName(name),
    //           const SizedBox(height: 25),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  productPrice(double price) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          Var.productPrice,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: Var.defaultFont,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          enabled: false,
          initialValue: "₱ ${price.toString()}",
          // controller: _productPriceController,
          // focusNode: _productPriceFocusNode,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontFamily: Var.defaultFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Colors.green
          ),
          decoration: InputDecoration(
            hintText: Var.productPrice,
            filled: true,
            isCollapsed: true,
            prefixIcon: const Icon(ProjectBuilder.price, size: 20),
            contentPadding:
                const EdgeInsets.only(top: 24, bottom: 24, left: 15, right: 10),
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

  productDescription(String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          Var.productDescription,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: Var.defaultFont,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          enabled: false,
          initialValue: description,
          // controller: _productDescriptionController,
          // focusNode: _productDescriptionFocusNode,
          validator: (value) => InputValidator.validateName(
              name: value!, label: Var.productDescription),
          minLines: 4,
          maxLines: 5,
          style: const TextStyle(
            fontFamily: Var.defaultFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Colors.green
          ),
          decoration: InputDecoration(
            hintText: Var.productDescription,
            filled: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 5, 20),
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            // prefixIcon: const Icon(ProjectBuilder.description, size: 20),
          ),
        ),
      ],
    );
  }

  Row productImage(BuildContext context, String? img) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Var.productImage,
              style: TextStyle(
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
                onTap: () => imageUpload(context, Var.productImage),
                child: 
                  Image.network(
                    img ?? Var.noImageAvailable,
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

  Row productName(String name) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text(
              Var.productName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin: EdgeInsets.zero,
              width: 330,
              height: 78,
              child: 
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    initialValue: name,
                    // controller: _productNameController,
                    // focusNode: _productNameFocusNode,
                    // validator: (value) =>
                    //   InputValidator.validateName(
                    //     name: name,
                    //     label: Var.productName
                    //   ),
                    style: const TextStyle(
                      fontFamily: Var.defaultFont,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: Colors.green
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: Var.productName,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                      fillColor: AppColors.input,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(ProjectBuilder.product, size: 20),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ],
    );
  }
  
  productCategory(String category) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Var.productCategory,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin: EdgeInsets.zero,
              width: 330,
              height: 78,
              child: 
                Expanded(
                  child: 
                  DropdownButtonFormField(
                    value: category,
                    items: Var.categories.map((String category) {
                      return DropdownMenuItem(
                        enabled: false,
                        value: category,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.shopping_basket_outlined),
                            const SizedBox(width: 5),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontFamily: Var.defaultFont,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        );
                      }).toList(),
                      onChanged: (value) {
                        // setState(() {
                        //   _productCategoryValue = value.toString();
                        // });
                      },
                      // value: _category,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: Var.selectCategory, 
                        )
                    )
                ),
            ),
          ],
        ),
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
          .child("${Var.imagesRef}${Var.products}/${Var.charRandomizer()}${Var.jpeg}")
          .putFile(file)
          .snapshotEvents.listen((taskSnapshot) async {
            switch (taskSnapshot.state) {
              case TaskState.running:
                final progress =
                    100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                Toast.show("${Var.uploading} $progress%");
                Loader.show(context, 0);
                break;
              case TaskState.success:
                Toast.show(Var.uploadingCompleted);
                String downloadURL = await taskSnapshot.ref.getDownloadURL();
                // setState(() => productImagePath = downloadURL);
                Loader.stop();
                break;
              case TaskState.paused:
                Toast.show(Var.uploadingPaused);
                Loader.stop();
                break;
              case TaskState.canceled:
                Toast.show(Var.uploadingCanceled);
                Loader.stop();
                break;
              case TaskState.error:
                Toast.show(Var.uploadingError);
                Loader.stop();
                break;
            }
          });
      } else {
        Toast.show(Var.noImageReceived);
      }
  }