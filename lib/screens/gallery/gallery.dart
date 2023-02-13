import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialPage;

  GalleryScreen(this.images, {this.initialPage = 0});

  @override
  State<StatefulWidget> createState() => _GalleryScreenState(initialPage: initialPage);

}

class _GalleryScreenState extends State<GalleryScreen> {
  int initialPage;

  late PageController _galleryController;

  var _currentPage = 0;

  _GalleryScreenState({this.initialPage = 0});

  @override
  void initState() {
    super.initState();
    _currentPage = initialPage;
    _galleryController = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              '${_currentPage+1}/${widget.images.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ),
        )
      ],
    ),
    body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.images.length,
          builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.images[index]),
              initialScale: PhotoViewComputedScale.contained * 1.0,
              minScale: PhotoViewComputedScale.contained * 0.8
          ),
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          pageController: _galleryController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          backgroundDecoration: BoxDecoration(color: Colors.black),
        ),
      ),
    ),
  );
}