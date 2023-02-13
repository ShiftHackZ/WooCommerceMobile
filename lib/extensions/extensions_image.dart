import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';

Future<Color> getColor(String path) async {
  print("_getColor");
  Uint8List data;
  img.Image photo;

  try {
    data =
        (await NetworkAssetBundle(
            Uri.parse(path)).load(path))
            .buffer
            .asUint8List();

    print("setImageBytes....");
    List<int> values = data.buffer.asUint8List();
    photo = img.decodeImage(values)!;

    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");

    return Color(hex);
  }
  catch(ex){
    print(ex.toString());
    return Colors.black;
  }
}

int abgrToArgb(int argbColor) {
  print("abgrToArgb");
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
