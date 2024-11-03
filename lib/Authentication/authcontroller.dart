import 'package:get/get.dart';

class AuthController extends GetxController {
  var isSignIn = true.obs;

  void toggleForm() {
    isSignIn.value = !isSignIn.value;
  }
}
