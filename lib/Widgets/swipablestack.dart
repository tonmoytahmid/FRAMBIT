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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      
      children: [
        SizedBox(height: 120,),
        Container(
          padding: EdgeInsets.all(10),
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                    child:
                        //  CachedNetworkImage(
                        //   imageUrl: widget.imageUrls[currentIndex],
                        //   fit: BoxFit.fill,
                        //   placeholder: (context, url) {
                        //     return Center(
                        //       child: CircularProgressIndicator(),
                        //     );
                        //   },
                        //   errorWidget: (context, url, error) {
                        //     return Center(child: Text('Failed to load image'));
                        //   },
                        // )
            
                        Image.network(
                      widget.imageUrls[currentIndex],
                      fit: BoxFit.fill,
                      height: 500,
                      width: 500,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Failed to load image'));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
