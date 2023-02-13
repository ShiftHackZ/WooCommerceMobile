import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/extensions/extensions_product.dart';

class CategoryInfoScreen extends StatelessWidget {

  final String name;
  final String description;
  final String image;
  final String link;

  CategoryInfoScreen(this.name, this.description, this.image, {this.link = ''});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(name),
    ),
    body: SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(parseHtml(description))
            ],
          ),
        ),
      ),
    ),
  );

}