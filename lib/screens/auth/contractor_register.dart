import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../core/models/contractor.dart';
import '../../core/models/user.dart';
import '../../core/models/address.dart';
import '../../core/providers/user.dart';
import '../../core/utils/global.dart';
import '../../core/utils/toast.dart';
import '../../core/utils/validator.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../styles/icons/builder_icons.dart';
import '../../styles/ui/colors.dart';
import '../roles/admin/items.dart';
import 'login.dart';
import 'package:device_info/device_info.dart';

class ContractorRegister extends StatefulWidget {
  static const id = "Contractor Register";
  const ContractorRegister({Key? key}) : super(key: key);

  @override
  State<ContractorRegister> createState() => _ContractorRegisterState();
}

class _ContractorRegisterState extends State<ContractorRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();
  final ValueNotifier<Address?> _addressController = ValueNotifier(null);
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  String permitImagePath = Var.noImageAvailable;
  bool isloaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => AuthRouter.router.currentState!
              .popAndPushNamed(AuthRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Create your Account",
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    authInput(
                      hint: "Name",
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      inputType: TextInputType.name,
                      validator: (value) =>
                          InputValidator.validateName(name: value),
                      prefix: const Icon(
                        ProjectBuilder.user,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Enter your Email",
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      inputType: TextInputType.emailAddress,
                      validator: (value) =>
                          InputValidator.validateEmail(email: value),
                      prefix: const Icon(
                        Icons.email_rounded,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Enter your Password",
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      validator: (value) =>
                          InputValidator.validatePassword(password: value),
                      inputType: TextInputType.visiblePassword,
                      private: true,
                      prefix: const Icon(
                        Icons.lock_rounded,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Confirm your Password",
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      validator: (value) =>
                          InputValidator.validatePassword(password: value),
                      inputType: TextInputType.visiblePassword,
                      private: true,
                      prefix: const Icon(
                        Icons.lock_rounded,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Enter your Phone Number",
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      inputType: TextInputType.phone, //TextInputType.phone,
                      // validator: (value) =>
                      //     InputValidator.validatePhone(phone: value),
                      prefix: const Icon(
                        Icons.phone_rounded,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Company Name",
                      controller: _companyNameController,
                      focusNode: _companyNameFocusNode,
                      inputType: TextInputType.name,
                      validator: (value) =>
                          InputValidator.validateName(name: value),
                      prefix: const Icon(
                        ProjectBuilder.user,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 15),
                    authInput(
                      hint: "Enter your Address",
                      controller: _addressTextController,
                      focusNode: _addressFocusNode,
                      inputType: TextInputType.streetAddress,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AppDialog(
                          child: FlutterLocationPicker(
                            initZoom: 11,
                            minZoomLevel: 5,
                            maxZoomLevel: 16,
                            trackMyPosition: true,
                            selectLocationButtonText: 'Select Contractor Location',
                            selectLocationButtonStyle: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(AppColors.primary),
                            ),
                            markerIcon: ProjectBuilder.client,
                            markerIconColor: AppColors.primary,
                            searchBarBackgroundColor: AppColors.input,
                            zoomButtonsBackgroundColor: AppColors.primary,
                            locationButtonBackgroundColor: AppColors.primary,
                            onPicked: (pickedData) {
                              _addressTextController.text = pickedData.address;
                              Navigator.of(context, rootNavigator: true).pop();
                              _addressController.value = Address(
                                  name: pickedData.address.toString(),
                                  position: LatLng(pickedData.latLong.latitude,
                                      pickedData.latLong.longitude));
                            },
                          ),
                        ),
                      ),
                      validator: (value) => InputValidator.validateAddress(
                          address: _addressController.value),
                      prefix: const Icon(
                        ProjectBuilder.location,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "PERMIT",
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.zero,
                      height: 150,
                      width: 150,
                      child: 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(permitImagePath)
                          // child: !isloaded
                          //   ? Image.network(Var.noImageAvailable)
                          //   : Image.network(permitImagePath)
                        ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 65),
                      child:
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.zero,
                              height: 40,
                              width: 125,
                              child:
                                ElevatedButton(
                                  onPressed: () => imageUpload(),
                                  child:
                                    const Text(
                                      "Choose Image from Gallery",
                                      style: TextStyle(
                                        fontFamily: Var.defaultFont,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              margin: EdgeInsets.zero,
                              height: 40,
                              width: 125,
                              child: 
                                ElevatedButton(
                                  onPressed: () => imageUpload(),
                                  child:
                                    const Text(
                                      "Upload image from Camera",
                                      style: TextStyle(
                                        fontFamily: Var.defaultFont,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                ),
                            ),
                          ]
                        ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: kIsWeb ? 50 : null,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _userRegister(
                              context: context,
                              username: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              phone: _phoneController.text,
                              address: _addressController.value!,
                              role: Contractor.role,
                              companyName: _companyNameController.text,
                              permit: permitImageFile,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 124),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _userRegister({
    required String username,
    required BuildContext context,
    required String email,
    required String password,
    required String phone,
    required Address address,
    required String role,
    required String companyName,
    required File permit,
  }) {
    print("_userRegister _companyNameController.text -> ${_companyNameController.text} |  permitImageFile -> $permitImageFile");
    Provider.of<UserProvider>(context, listen: false).createUser(
      context: context,
      signInMethods: SignInMethods.email,
      payload: UserModel(
        name: username,
        email: email,
        password: password,
        phone: phone,
        address: address,
        roles: role, //[Roles.user],
        companyName: companyName,
        permit: permit,
      )
    );
  }

  imageUpload() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    var downloadURL;

    PickedFile? image;
    // ignore: use_build_context_synchronously
    FocusScope.of(context).requestFocus(FocusNode());

    await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.manageExternalStorage,
    ].request();

    image = await _imagePicker.getImage(source: ImageSource.gallery);
    var file = File(image?.path ?? Var.noImageAvailable);
    if (image != null) {
      _firebaseStorage.ref()
        .child("${Var.imagesRef}${Var.permitRef}${Var.charRandomizer()}${Var.jpeg}")
        .putFile(file)
        .snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress =
                  100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              Toast.show("${Var.uploadingIs} $progress% ${Var.complete}");
              break;
            case TaskState.success:
              Toast.show(Var.uploadingCompleted);
              downloadURL = await taskSnapshot.ref.getDownloadURL();
              // Toast.show(downloadURL);
              setState(() {
                permitImagePath = downloadURL;
                // permitImageFile = File("${media.galleryMode}");
                isloaded = true;
              });
              break;
            case TaskState.paused:
              Toast.show(Var.uploadingPaused);
              break;
            case TaskState.canceled:
              Toast.show(Var.uploadingCanceled);
              break;
            case TaskState.error:
              Toast.show(Var.uploadingError);
              break;
          }
        });
      // uploadPermit.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      //   switch (taskSnapshot.state) {
      //     case TaskState.running:
        //     final progress =
        //         100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        //     Toast.show("${Var.uploadingIs} $progress% ${Var.complete}");
        //     break;
        //   case TaskState.paused:
        //     Toast.show(Var.uploadingPaused);
        //     break;
        //   case TaskState.canceled:
        //     Toast.show(Var.uploadingCanceled);
        //     break;
        //   case TaskState.error:
        //     Toast.show(Var.uploadingError);
        //     break;
        //   case TaskState.success:
        //     Toast.show(Var.uploadingCompleted);
        //     var permitURL = await taskSnapshot.ref.getDownloadURL();
        //     storeNewUser(
        //       credentials.user!.uid,
        //       payload.email,
        //       payload.password,
        //       payload.name,
        //       payload.phone,
        //       payload.address,
        //       payload.roles,
        //       payload.userCompanyName,
        //       permitURL,
        //     );
        //     break;
        // }
      // });
    } else {
      Toast.show('No Image Path Received');
    }
  }

  // Future<void> pickImageFromCameraGallery(String imageMode) async {
  //   if (imageMode == Var.camera) {
  //     ImagePickers.openCamera().then((Media? media) {
  //       if (media != null){
  //         setState(() {
  //           permitImagePath = File("${media.path}");
  //           permitImageFile = File("${media.galleryMode}");
  //           isloaded = true;
  //         });
  //       } else {
  //         setState(() => isloaded = false);
  //       }
  //     });
  //     return;
  //   }
    
  //   List<Media> medias = await ImagePickers.pickerPaths(
  //     galleryMode: GalleryMode.image,
  //     selectCount: 2,
  //     showGif: false,
  //     showCamera: true,
  //     compressSize: 500,
  //     uiConfig: UIConfig(uiThemeColor: Colors.black),
  //     cropConfig: CropConfig(enableCrop: false, width: 2, height: 1)
  //   );
  //   if (medias.isNotEmpty) {
  //     setState(() {
  //       permitImagePath = File("${medias[0].path}");
  //       permitImageFile = File("${medias[0].galleryMode}");
  //       print("imagePicker chooseGallery media -> $permitImageFile");
  //       isloaded = true;
  //     });
  //   } else {
  //     setState(() => isloaded = false);
  //   }
  // }

  // static Future<bool> checkPermission(
  //   BuildContext context,
  //   String permissionName
  // ) async {
  //   if (Platform.isAndroid) {
  //     final androidInfo = await DeviceInfoPlugin().androidInfo;
  //     final sdkInt = androidInfo.version.sdkInt;
  //     if (sdkInt < 33 && permissionName == 'gallery') {
  //       return true;
  //     }
  //   }
  //   FocusScope.of(context).requestFocus(FocusNode());
  //   Map<Permission, PermissionStatus> statues;
  //   switch (permissionName) {
  //     case 'camera': {
  //       statues = await [Permission.camera].request();
  //       PermissionStatus? statusCamera = statues[Permission.camera];
  //       if (statusCamera == PermissionStatus.granted) {
  //         return true;
  //       } else if (statusCamera == PermissionStatus.permanentlyDenied) {
  //         return false;
  //       } else {
  //         return false;
  //       }
  //     }
  //     case 'gallery': {
  //       statues = await [Permission.photos].request();
  //       PermissionStatus? statusPhotos = statues[Permission.photos];
  //       if (statusPhotos == PermissionStatus.granted) {
  //         return true;
  //       } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
  //         return false;
  //       } else if (statusPhotos == PermissionStatus.limited) {
  //         return false;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }
  //   return false;
  // }

}