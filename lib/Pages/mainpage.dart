import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/Fatching/userinformationfatching.dart';
import 'package:flutter_application_2/Pages/viewimagepage.dart';
import 'package:flutter_application_2/Widgets/cardwidgets.dart';
import 'package:get/get.dart';

import 'settingpage.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GetUserDataController userdata = Get.put(GetUserDataController());
  User user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0;
  List<List<String>> pages = [];
  List<String> categoryLabels = [
    "Popular Ideas 👌",
    "Digital Ideas ❤️",
    "Special 😎"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF6A00FF),
        title: FutureBuilder<String>(
          future: userdata.getUsername(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            } else if (snapshot.hasError) {
              return Text("Error");
            } else {
              return Text(
                "Hello ${snapshot.data}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.white),
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => Settingpage());
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('product_name').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, List<QueryDocumentSnapshot>> categorizedProducts = {};
            for (var doc in snapshot.data!.docs) {
              String category = doc['category'];
              if (categorizedProducts.containsKey(category)) {
                categorizedProducts[category]!.add(doc);
              } else {
                categorizedProducts[category] = [doc];
              }
            }

            pages.clear();
            var categories = categorizedProducts.keys.toList();
            for (var i = 0; i < categories.length; i += 2) {
              pages.add(categories.sublist(
                  i, i + 2 > categories.length ? categories.length : i + 2));
            }

            if (pages.isEmpty || _currentIndex >= pages.length) {
              return Center(child: Text('No categories to display'));
            }

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: pages[_currentIndex].map((category) {
                return Center(
                  child: CardWidget(
                    title: category,
                    onTap: () {
                      Get.to(() => CategoryImagesPage(category: category));
                    },
                    categoryLabel: categoryLabels[_currentIndex],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        categories: categoryLabels,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final List<String> categories;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.categories,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF6A00FF),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(categories.length, (index) {
            bool isSelected = currentIndex == index;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
