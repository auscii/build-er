import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🏘️ Local imports
import '../../core/models/user.dart';
import '../../core/providers/user.dart';
import '../../core/utils/global.dart';
import '../../core/utils/loader.dart';
import '../../core/utils/validator.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../styles/ui/colors.dart';
import 'onboarding.dart';

class Login extends StatefulWidget {
  static const String id = "login";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    // _emailController.text = "sean@gmail.com";
    // _passwordController.text = "123qwe";
    super.initState();
  }
  
  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _emailFocusNode.removeListener(() { });
    _passwordFocusNode.removeListener(() { });
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
                buildBranding(context),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      authInput(
                        hint: "Enter your Email",
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        validator: (value) =>
                            InputValidator.validateEmail(email: value),
                        inputType: TextInputType.emailAddress,
                        prefix: const Icon(
                          Icons.email_rounded,
                          size: 15,
                        ),
                      ),
                      const SizedBox(height: 14),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: kIsWeb ? 50 : null,
                        child: ElevatedButton(
                          onPressed: () {
                            Loader.show(context, 0);
                            if (_formKey.currentState!.validate()) {
                              _userAuth(
                                context: context,
                                email: _emailController.text,
                                password: _passwordController.text,
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
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => AuthRouter.router.currentState!
                      .pushReplacementNamed(AuthRoutes.resetPassword),
                  child: const Text(
                    "Forgot password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 18,
                      fontFamily: Var.defaultFont,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                createAccountShortcut()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _userAuth({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    Provider.of<UserProvider>(context, listen: false).authUser(
      context: context,
      signInMethods: SignInMethods.email,
      email: email,
      password: password,
    );
  }
}

Widget authInput({
  String? hint,
  required TextEditingController? controller,
  required FocusNode focusNode,
  FormFieldValidator? validator,
  String? errorMessage,
  TextInputType? inputType,
  bool private = false,
  Widget? prefix,
  Widget? suffix,
  GestureTapCallback? onTap,
}) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      onTap: onTap,
      focusNode: focusNode,
      validator: validator,
      textAlignVertical: TextAlignVertical.center,
      obscureText: private,
      keyboardType: inputType,
      style: const TextStyle(
        fontFamily: Var.defaultFont,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
      decoration: InputDecoration(
        filled: true,
        isCollapsed: true,
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.fromLTRB(30, 17, 0, 17),
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        helperText: errorMessage,
        helperStyle: const TextStyle(
          fontFamily: Var.defaultFont,
          fontSize: 10,
          color: AppColors.error,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    ),
  );
}
