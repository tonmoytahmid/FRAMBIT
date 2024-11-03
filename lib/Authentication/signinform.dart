import 'package:flutter/material.dart';
import 'package:flutter_application_2/Authcontroller/googlesignincontroller.dart';
import 'package:flutter_application_2/Authcontroller/signincontroller.dart';
import 'package:flutter_application_2/Authentication/forgotpasswordpage.dart';
import 'package:flutter_application_2/Pages/mainpage.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignInForm extends StatelessWidget {
  SignInForm({super.key});
  Signincontroller signincontroller = Get.put(Signincontroller());
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  GoogleSignInController googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email TextField
        TextField(
          controller: emailcontroller,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 20),

        // Password TextField
        Obx(
          () => TextField(
            controller: passwordcontroller,
            obscureText: signincontroller.showpass.value,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  signincontroller.showpass.toggle();
                },
                child: signincontroller.showpass.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        // Sign In Button
        ElevatedButton(
          onPressed: () async {
            // Handle sign-in logic here
            String email = emailcontroller.text.trim();
            String password = passwordcontroller.text.trim();

            if (email.isNotEmpty || password.isNotEmpty) {
              await signincontroller.Signinmethod(email, password);

              Get.offAll(() => Mainpage());
            } else {
              Get.snackbar("Please check", "Fillup the all requirments",
                  duration: Duration(seconds: 5),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  backgroundColor: Colors.grey);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A00FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          ),
          child: Text(
            'Sign In',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        SizedBox(height: 20),

        // Forgot Password
        TextButton(
          onPressed: () {
            Get.to(() => ForgotpasswordPage());
          },
          child: Text(
            'Forgot Password',
            style: TextStyle(color: Color(0xFF6A00FF)),
          ),
        ),
        SizedBox(height: 20),

        // Or sign up with
        Text(
          'Or sign up with',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 20),

        // Google Sign-In Button
        ElevatedButton.icon(
            onPressed: () async {
              await googleSignInController.signInWithGoogle();
            },
            icon: Icon(Icons.g_mobiledata),
            label: Text('Continue with Google'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.grey),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ))
      ],
    );
  }
}
