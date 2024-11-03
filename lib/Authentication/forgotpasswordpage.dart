import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  TextEditingController emailcontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A00FF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Forgot password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Send your email to reset your password..",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailcontroller.text.trim();
                if (email.isNotEmpty) {
                  EasyLoading.show(status: 'Please wait');
                  await auth.sendPasswordResetEmail(email: email);
                  setState(() {
                    emailcontroller.clear();
                  });

                  EasyLoading.dismiss();
                  Get.snackbar(
                      "Please check", "Rest link is sended to your email",
                      duration: Duration(seconds: 5),
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.black,
                      backgroundColor: Colors.grey);
                } else {
                  Get.snackbar("Please check", "Required fill is empty",
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
                'Send',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
