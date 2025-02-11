import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_meters_marker/components/custom_text_form_field.dart';
import 'package:map_meters_marker/cubits/map_cubit.dart';
import 'package:map_meters_marker/models/DataBase.dart';
import 'package:map_meters_marker/models/login_view_model.dart';
import 'package:map_meters_marker/view/map_view.dart';
import 'package:map_meters_marker/view/signup_view.dart';

class LoginView extends StatelessWidget {
  static const route = "/login";
  final LoginControllers loginControllers = LoginControllers();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LoginView({super.key});

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
                  "SignIn",
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
                          if (!loginControllers.isValidEmail(value!)) {
                            return "invalid email";
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
                            if (!loginControllers.isValidPassword(value!)) {
                              return "password invalid";
                            }

                            return null;
                          }),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final isValid = await loginControllers.validateLogin();
                      if (isValid) {
                        var user = await DBHelper.getUserByEmail(
                            loginControllers.emailController.text);
                        if (user != null) {
                          int userId = user['id'] as int;

                          Navigator.pushReplacementNamed(
                              context, MapView.route);
                        }
                        if (user != null && context.mounted) {
                          context
                              .read<MapCubit>()
                              .setCurrentUser(user['id'] as int);
                          //context.read<MapCubit>().loadMarkersForUser(user['id'] as int);

                          Navigator.pushNamed(context, MapView.route);
                        }
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
                      "Login",
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
                      Navigator.pushNamed(context, SignupView.route);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't Have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Register",
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
