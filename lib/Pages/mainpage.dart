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
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;
  List<List<String>> pages = [];
  List<String> categoryLabels = [
    "Popular Ideas 👌",
    "Digital Ideas ❤️",
    "Special 😎"
  ];
  String? userImage;
  String? userName;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['Name'];

            userImage = userDoc['image'];
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/backgroundimage.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hello, ${userName ?? '[Display Name]'}!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // FutureBuilder<String>(
              //   future: userdata.getUsername(user!.uid),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Text("Loading...");
              //     } else if (snapshot.hasError) {
              //       return Text("Error");
              //     } else {
              //       return Text(
              //         "Hello, ${snapshot.data}",
              //         style: TextStyle(
              //             fontSize: 17,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white),
              //       );
              //     }
              //   },
              // ),
              GestureDetector(
                onTap: () {
                  Get.to(() => Settingpage());
                },
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    userImage ??
                        'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
                  ),
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
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
              return Center(
                  child: Text(
                'No categories to display',
                style: TextStyle(color: Colors.white),
              ));
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
        bottomNavigationBar: CustomBottomNavBar(
          categories: categoryLabels,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final List<String> categories;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.categories,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF181818),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(categories.length, (index) {
          bool isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF333333) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
