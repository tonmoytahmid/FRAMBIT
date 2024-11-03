import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Pages/mainpage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Signincontroller extends GetxController {
  RxBool showpass = false.obs;

  Future<UserCredential?> Signinmethod(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      EasyLoading.show(status: 'Please wait');
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      EasyLoading.dismiss();
      Get.offAll(() => Mainpage());
      return userCredential;
    } catch (e) {
      EasyLoading.dismiss();
      _handleError(e);
    }
    return null; // Ensure a null return if an exception occurs
  }

  void _handleError(dynamic e) {
    Get.snackbar("Error", e.toString(),
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        backgroundColor: Colors.grey);
  }
}
