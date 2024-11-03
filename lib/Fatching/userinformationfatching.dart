import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class GetUserDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUsername(String uid) async {
    final QuerySnapshot userData =
        await _firestore.collection('Users').where('uid', isEqualTo: uid).get();
    if (userData.docs.isNotEmpty) {
      return userData.docs.first
          .get('Name'); // Adjust 'Name' to the field storing the username
    }
    return "User";
  }
}
