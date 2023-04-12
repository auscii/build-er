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
import '../../core/utils/loader.dart';
import '../../core/utils/toast.dart';
import '../../core/utils/validator.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../styles/icons/builder_icons.dart';
import '../../styles/ui/colors.dart';
import '../roles/admin/add_products.dart';
import 'login.dart';

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
  final _firebaseStorage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();

  String permitImagePath = Var.noImageAvailable;
  String licenseImagePath = Var.noImageAvailable;
  String dtiImagePath = Var.noImageAvailable;
  String secImagePath = Var.noImageAvailable;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    clearInputs();
    super.dispose();
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
          onPressed: () => GlobalNavigator.router.currentState!
              .popAndPushNamed(AuthRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Var.startupBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    Var.createContractorAccount,
                    style: TextStyle(
                      fontFamily: Var.defaultFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: AppColors.info
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      authInput(
                        hint: Var.enterName,
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
                        hint: Var.enterEmail,
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
                        hint: Var.enterPassword,
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
                        hint: Var.confirmPassword,
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
                        hint: Var.enterPhone,
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
                        hint: Var.enterCompany,
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
                        hint: Var.enterAddress,
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
                              selectLocationButtonText: Var.selectLocation,
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
                      const SizedBox(height: 40),
                      const Text(
                        Var.permit,
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
                          ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => imageUpload(Var.permit),
                        child:
                          const Text(
                            Var.uploadFromGallery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        Var.license,
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
                            child: Image.network(licenseImagePath)
                          ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => imageUpload(Var.license),
                        child:
                          const Text(
                            Var.uploadFromGallery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        Var.dti,
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
                            child: Image.network(dtiImagePath)
                          ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => imageUpload(Var.dti),
                        child:
                          const Text(
                            Var.uploadFromGallery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        Var.sec,
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
                            child: Image.network(secImagePath)
                          ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => imageUpload(Var.sec),
                        child:
                          const Text(
                            Var.uploadFromGallery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        height: kIsWeb ? 50 : null,
                        child: ElevatedButton(
                          onPressed: () {
                            var password = _passwordController.text;
                            var confirmPassword = _confirmPasswordController.text;
                            if (_formKey.currentState!.validate()) {
                              if (password != confirmPassword) {
                                Toast.show(Var.passwordMismatched);
                                return;
                              }
                              UserProvider.userRegister(
                                context: context,
                                username: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                address: _addressController.value!,
                                role: Contractor.role,
                                companyName: _companyNameController.text,
                                permit: permitImagePath,
                                license: licenseImagePath,
                                dti: dtiImagePath,
                                sec: secImagePath,
                              );
                              clearInputs();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(
                              width: 2.0,
                              color: Colors.white,
                            )
                          ),
                          child: const Text(
                            Var.register,
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
      ),
    );
  }

  imageUpload(String activeUpload) async {
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
              Toast.show("${Var.uploading} $progress%");
              Loader.show(context, 0);
              break;
            case TaskState.success:
              Toast.show(Var.uploadingCompleted);
              String downloadURL = await taskSnapshot.ref.getDownloadURL();
              setState(() {
                if (activeUpload == Var.permit) {
                  permitImagePath = downloadURL;
                } else if (activeUpload == Var.license) {
                  licenseImagePath = downloadURL;
                } else if (activeUpload == Var.dti) {
                  dtiImagePath = downloadURL;
                } else if (activeUpload == Var.sec) {
                  secImagePath = downloadURL;
                }
              });
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

  clearInputs() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
    _companyNameController.clear();
    _addressTextController.clear();
    _addressController.removeListener(() {});
    _nameFocusNode.removeListener(() {});
    _emailFocusNode.removeListener(() {});
    _passwordFocusNode.removeListener(() {});
    _confirmPasswordFocusNode.removeListener(() {});
    _phoneFocusNode.removeListener(() {});
    _companyNameFocusNode.removeListener(() {});
    _addressFocusNode.removeListener(() {});
    permitImagePath = Var.noImageAvailable;
    licenseImagePath = Var.noImageAvailable;
    dtiImagePath = Var.noImageAvailable;
    secImagePath = Var.noImageAvailable;
  }

}