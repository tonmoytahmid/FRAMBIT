import 'package:flutter/material.dart';
import 'package:flutter_application_2/Authcontroller/signupcontroller.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  SignUpForm({super.key});
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();

  Signupcontroller signupcontroller = Get.put(Signupcontroller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name TextField
        TextField(
          controller: namecontroller,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 20),

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
            obscureText: signupcontroller.showpass.value,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  signupcontroller.showpass.toggle();
                },
                child: signupcontroller.showpass.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        // Confirm Password TextField
        Obx(
          () => TextField(
            controller: confirmpasscontroller,
            obscureText: signupcontroller.showcpass.value,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  signupcontroller.showcpass.toggle();
                },
                child: signupcontroller.showcpass.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        // Create Account Button
        ElevatedButton(
          onPressed: () async {
            // Handle sign-up logic here
            String name = namecontroller.text.trim();
            String email = emailcontroller.text.trim();
            String password = passwordcontroller.text.trim();
            String confirmpass = confirmpasscontroller.text.trim();
            if (name.isNotEmpty ||
                email.isNotEmpty ||
                password.isNotEmpty ||
                confirmpass.isNotEmpty) {
              await signupcontroller.Signupmethod(
                  name, email, password, confirmpass);
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
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          ),
          child: Text(
            'Create Account',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
