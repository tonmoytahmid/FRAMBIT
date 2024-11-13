import 'package:flutter/material.dart';
import 'package:flutter_application_2/Widgets/swipablestack.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryImagesPage extends StatefulWidget {
  final String category;

  CategoryImagesPage({super.key, required this.category});

  @override
  State<CategoryImagesPage> createState() => _CategoryImagesPageState();
}

class _CategoryImagesPageState extends State<CategoryImagesPage> {
  Future<void> _launchURL(String url) async {
    // Check if the URL starts with 'http://' or 'https://'
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      throw 'Invalid URL format: $url';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isAdlodad = false;

  late BannerAd bannerAd;

  // ignore: non_constant_identifier_names
  IntializeBannerad() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-1679533511475404/8805013784',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdlodad = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isAdlodad = false;
          print(error);
        },
      ),
      request: AdRequest(),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    IntializeBannerad();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ignore: unused_local_variable
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/backgroundimage.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white,weight: 40,size:40),
          title: Text(
            widget.category,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('product_name')
              .where('category', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<String> imageUrls = [];
            List<String> pageLinks = [];

            for (var doc in snapshot.data!.docs) {
              // Fetch the image URL and page link
              String imageUrl = doc['imageurl_link'] ?? '';
              String pageLink = doc['pageurl_link'] ?? '';

              // Only add valid URLs
              if (imageUrl.isNotEmpty &&
                  Uri.tryParse(imageUrl)?.hasScheme == true) {
                imageUrls.add(imageUrl);
              }

              if (pageLink.isNotEmpty &&
                  Uri.tryParse(pageLink)?.hasScheme == true) {
                pageLinks.add(pageLink);
              }
            }

            // Check if we have images to display
            if (imageUrls.isEmpty) {
              return Center(
                  child: Text('No images available for this category',style: TextStyle(color: Colors.white),));
            }

            return SwipableImageStack(
                imageUrls: imageUrls,
                pageLinks: pageLinks,
                isAdLoaded: isAdlodad,
                bannerAd: bannerAd,
                screenWidth: screenWidth);
          },
        ),
        bottomNavigationBar: isAdlodad == true
            ? SizedBox(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(ad: bannerAd),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
