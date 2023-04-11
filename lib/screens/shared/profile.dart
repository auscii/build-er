import 'package:client/core/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🏘️ Local imports
import '../../core/providers/user.dart';
import '../../core/utils/global.dart';
import '../../styles/ui/colors.dart';
import '../../router/navigator/navigation_menu.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 0, left: 30, right: 30),
      maintainBottomViewPadding: false,
      child: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
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
                  backgroundImage: const NetworkImage(Var.userPlaceholder),
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
                    onPressed: () {
                      Toast.show(Var.featureNotAvailable);
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
    );
  }
}
