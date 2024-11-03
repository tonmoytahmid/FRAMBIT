import 'package:flutter/material.dart';
import 'package:flutter_application_2/Authentication/authcontroller.dart';
import 'package:flutter_application_2/Authentication/signinform.dart';
import 'package:flutter_application_2/Authentication/signupform.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'images/logo.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 20),

                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => authController.isSignIn.value = true,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: authController.isSignIn.value
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: authController.isSignIn.value
                                  ? Color(0xFF6A00FF)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => authController.isSignIn.value = false,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: !authController.isSignIn.value
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: !authController.isSignIn.value
                                  ? Color(0xFF6A00FF)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 10),
                Divider(
                  color: Color(0xFF6A00FF),
                  thickness: 2,
                ),
                SizedBox(height: 20),

                // Form
                Obx(() => authController.isSignIn.value
                    ? SignInForm()
                    : SignUpForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
