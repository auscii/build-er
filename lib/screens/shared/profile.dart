import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/core/utils/validator.dart';
import 'package:client/router/router.dart';
import 'package:client/screens/roles/admin/add_products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/user.dart';
import '../../core/utils/global.dart';
import '../../styles/ui/colors.dart';
import '../../router/navigator/navigation_menu.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _adddressFocusNode = FocusNode();
  final FocusNode _phonenumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // minimum: const EdgeInsets.only(top: 30),
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
            ),
          ),
          child: ConstrainedBox(
            constraints: pageConstraints,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      Var.profile,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      minRadius: 30,
                      maxRadius: 80,
                      backgroundColor: AppColors.input.withOpacity(0.7),
                      backgroundImage: const AssetImage(Var.userPlaceholder),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "NAME: ${Provider.of<UserProvider>(context).user.name ?? Var.na}",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "USER ID: ${Provider.of<UserProvider>(context).user.uid ?? Var.na}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "EMAIL: ${Provider.of<UserProvider>(context).user.email ?? Var.na}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "ADDRESS: ${Provider.of<UserProvider>(context).user.address?.name ?? Var.na}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "PHONE NUMBER: ${Provider.of<UserProvider>(context).user.phone ?? Var.na}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: kIsWeb ? 50 : null,
                      child: ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => updateProfile(
                            context,
                            Provider.of<UserProvider>(context).user.uid ?? Var.na
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 124),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget updateProfile(
    BuildContext context,
    String uid
  ) {
    return AppDialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "UPDATE PROFILE",
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
                _nameController,
                _nameFocusNode,
                "Name"
              ),
              // const SizedBox(height: 25),
              // textArea(
              //   _addressController,
              //   _adddressFocusNode,
              //   "Address"
              // ),
              const SizedBox(height: 25),
              textArea(
                _phonenumberController,
                _phonenumberFocusNode,
                "Phone Number"
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<AppData>(context, listen: false)
                    .updateUserProfile(
                      userId: uid,
                      name: _nameController.text,
                      // address: _addressController.text,
                      phone: _phonenumberController.text,
                    ).then(
                      (value) {
                        GlobalNavigator.goBack();
                        Provider.of<UserProvider>(
                          context, 
                          listen: false
                        ).signOut(context);
                        // NavigationMenu.activeIndex = 1;
                        // GlobalNavigator.navigateToScreen(const NavigationMenu());
                      },
                    );
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

}
