import 'package:flutter/material.dart';

import 'package:swipable_stack/swipable_stack.dart';
import 'package:url_launcher/url_launcher.dart';

class SwipableImageStack extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> pageLinks;
  final bool isAdLoaded;
  final dynamic bannerAd;
  final double screenWidth;

  SwipableImageStack({
    required this.imageUrls,
    required this.pageLinks,
    required this.isAdLoaded,
    required this.bannerAd,
    required this.screenWidth,
  });

  @override
  _SwipableImageStackState createState() => _SwipableImageStackState();
}

class _SwipableImageStackState extends State<SwipableImageStack> {
  late final SwipableStackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      throw 'Invalid URL format: $url';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10, top: 10),
      width: 500,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwipableStack(
        controller: _controller,
        itemCount: 100000,
        onSwipeCompleted: (index, direction) {},
        builder: (context, properties) {
          final currentIndex = properties.index % widget.imageUrls.length;
          return GestureDetector(
            onTap: () => _launchURL(widget.pageLinks[currentIndex]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.imageUrls[currentIndex],
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Failed to load image'));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
