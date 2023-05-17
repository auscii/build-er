import 'dart:io';
import 'package:client/core/models/products.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../core/models/client.dart';
import '../../../core/providers/appdata.dart';
import '../../../core/utils/validator.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/icons/builder_icons.dart';
import '../../../styles/ui/colors.dart';

class AppDialog extends StatelessWidget {
  final Widget child;
  const AppDialog({
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Dialog(
          backgroundColor: AppColors.bgDark,
          insetPadding:
              const EdgeInsets.only(top: 24, bottom: 24, right: 10, left: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Administrator ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: Var.defaultFont,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            onChanged: (value) => runFilter(value),
            style: const TextStyle(
              fontFamily: Var.defaultFont,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
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
              hintText: "Search for User",
            ),
          ),
          const SizedBox(height: 25),
          Expanded(flex: 4, child: getUsers()),
        ],
      ),
    );
  }

  late List<Client> users = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('client')
        .withConverter(
          fromFirestore: Client.fromFirestore,
          toFirestore: (Client userModel, _) => userModel.toFirestore(),
        )
        .snapshots()
        .listen((val) {
      setState(() {
        users = val.docs
            .map((QueryDocumentSnapshot<Client> clientSnapshot) =>
                clientSnapshot.data())
            .toList();
      });
    });
  }

  void runFilter(String enteredKeyword) {
    List<Client> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = users;
    } else {
      results = users
              .where((client) => client.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList()
              .isEmpty
          ? users
          : users
              .where((client) => client.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      users = results;
    });
  }

  Widget getUsers() {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemCount: users.length,
      itemBuilder: (_, i) {
        return RoundedTile(
          label: users[i].name,
          avatar: Image.network(users[i].image),
          icon: const Icon(ProjectBuilder.add),
        );
      },
    );
  }
}

class RoundedTile extends StatelessWidget {
  const RoundedTile({
    Key? key,
    this.label,
    required this.icon,
    required this.avatar,
    this.onPressed,
  }) : super(key: key);

  final String? label;
  final Widget icon;
  final Widget avatar;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: avatar,
          ),
          Expanded(
            child: Text(
              label ?? '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              // minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
            ),
            child: icon,
          ),
        ],
      ),
    );
  }
}

class AddProduct extends StatefulWidget {
  static const id = Var.addProduct;
  final bool admin;
  const AddProduct({
    Key? key,
    required this.admin
  }) : super(key: key);
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _productImageFocusNode = FocusNode();
  final FocusNode _productDescriptionFocusNode = FocusNode();
  final FocusNode _productPriceFocusNode = FocusNode();
  static String productImagePath = Var.noImageAvailable;
  static String _productCategoryValue = Var.na;

  @override
  void initState() {
    setState(() => Var.appTitle = Var.addProduct);
    super.initState();
  }

  @override
  void dispose() {
    clearInputs(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      // child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Var.appTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 35),
                productImage(context),
                const SizedBox(height: 25),
                productName(),
                const SizedBox(height: 25),
                productCategory(),
                const SizedBox(height: 25),
                productDescription(),
                const SizedBox(height: 25),
                productPrice(),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.admin) {
                        Provider.of<AppData>(context, listen: false)
                          .createProduct(
                            product: Product(
                              id: "${Var.productCode}${Var.charRandomizer()}",
                              image: productImagePath,
                              title: _productNameController.text,
                              description: _productDescriptionController.text,
                              price: double.parse(_productPriceController.text),
                              category: _productCategoryValue,
                              createdBy: FirebaseAuth.instance.currentUser!.uid,
                              dateTimeCreated: Timestamp.now()
                            ),
                          ).then(
                            (value) {
                              clearInputs(false);
                              GlobalNavigator.goBack();
                            },
                          );
                      }
                    } else {
                      Toast.show(Var.unableSave, null);
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
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      // ),
    );
  }

  productPrice() {
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
          controller: _productPriceController,
          focusNode: _productPriceFocusNode,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontFamily: Var.defaultFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
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

  productDescription() {
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
          controller: _productDescriptionController,
          focusNode: _productDescriptionFocusNode,
          validator: (value) => InputValidator.validateName(
              name: value!, label: Var.productDescription),
          minLines: 4,
          maxLines: 5,
          style: const TextStyle(
            fontFamily: Var.defaultFont,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
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

  Row productImage(BuildContext context) {
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
                child: getImage(),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Row productName() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
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
                    controller: _productNameController,
                    focusNode: _productNameFocusNode,
                    validator: (value) =>
                      InputValidator.validateName(
                        name: value!,
                        label: Var.productName
                      ),
                    style: const TextStyle(
                      fontFamily: Var.defaultFont,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
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
  
  productCategory() {
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
                    items: Var.categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.shopping_basket_outlined),
                            const SizedBox(width: 2),
                            Text(category),
                          ],
                        )
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _productCategoryValue = value.toString();
                        });
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

  clearInputs(bool shouldDisposeNow) {
    productImagePath = Var.noImageAvailable;
    if (shouldDisposeNow) {
      _productNameController.dispose();
      _productDescriptionController.dispose();
      _productPriceController.dispose();
      _productImageController.dispose();
      _productNameFocusNode.dispose();
      _productImageFocusNode.dispose();
      _productDescriptionFocusNode.dispose();
      _productPriceFocusNode.dispose();
      return;
    }
    _productNameController.clear();
    _productDescriptionController.clear();
    _productPriceController.clear();
    _productImageController.clear();
  }

  getImage() {
    return Image.network(
      productImagePath,
      errorBuilder: (_, __, ___) {
        return const FlutterLogo(size: 78);
      },
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
                Toast.show("${Var.uploading} $progress%", null);
                Loader.show(context, 0);
                break;
              case TaskState.success:
                Toast.show(Var.uploadingCompleted, null);
                String downloadURL = await taskSnapshot.ref.getDownloadURL();
                setState(() => productImagePath = downloadURL);
                Loader.stop();
                break;
              case TaskState.paused:
                Toast.show(Var.uploadingPaused, null);
                Loader.stop();
                break;
              case TaskState.canceled:
                Toast.show(Var.uploadingCanceled, null);
                Loader.stop();
                break;
              case TaskState.error:
                Toast.show(Var.uploadingError, null);
                Loader.stop();
                break;
            }
          });
      } else {
        Toast.show(Var.noImageReceived, null);
      }
  }

}