import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_meters_marker/components/custom_alert_dialogue.dart';
import 'package:map_meters_marker/components/custom_text_form_field.dart';
import 'package:map_meters_marker/cubits/map_cubit.dart';
import 'package:map_meters_marker/models/login_view_model.dart';
import 'package:map_meters_marker/view/login_view.dart';
import 'package:map_meters_marker/view/map_view.dart';

class SignupView extends StatelessWidget {
  static const route = "/signup";
  final LoginControllers loginControllers = LoginControllers();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SignUp",
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        isPassword: false,
                        controller: loginControllers.emailController,
                        hintText: "Email",
                        label: "Email",
                        prefix: Icons.mail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!loginControllers.isValidEmail(value)) {
                            return "Invalid Email format";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        isPassword: true,
                        controller: loginControllers.passwordController,
                        hintText: "Password",
                        label: "Password",
                        prefix: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!loginControllers.isValidPassword(value)) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      final newUserId = await loginControllers.validateSignUp();
                      if (newUserId != null && context.mounted) {
                        context.read<MapCubit>().setCurrentUser(newUserId);
                        //  context.read<MapCubit>().loadMarkersForUser(newUserId);

                        Navigator.pushNamed(context, MapView.route);
                      }
                    } else if (await loginControllers.validateLogin()) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialogue(
                              text: "User ALready Exist Try To Login",
                              icon: Icons.error,
                              color: Colors.red,
                            );
                          },
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialogue(
                              text: "Email or Password are not valid",
                              icon: Icons.error,
                              color: Colors.red,
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.blueAccent,
                    ),
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, LoginView.route);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
