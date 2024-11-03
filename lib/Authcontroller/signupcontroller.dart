import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  RxBool showpass = false.obs;
  RxBool showcpass = false.obs;

  Future<UserCredential?> Signupmethod(
      String name, String email, String password, String confirmpas) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore store = FirebaseFirestore.instance;

    try {
      EasyLoading.show(status: "Please wait");

      if (password == confirmpas) {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // Store user information in Firestore
        await store.collection('Users').doc(userCredential.user!.uid).set({
          'Name': name,
          'uid': userCredential.user!.uid,
          'Email': email,
          'image': '',
          'isAdmin': false,
        });

        EasyLoading.dismiss();

        return userCredential;
      } else {
        EasyLoading.dismiss();
        Get.snackbar("Error", "Passwords do not match",
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            colorText: Colors.black,
            backgroundColor: Colors.grey);
      }
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
