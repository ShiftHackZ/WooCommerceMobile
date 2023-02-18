import 'package:flutter/material.dart';

InputDecoration decorateTextFormField(String label, {String prefix = '', String? errorText,}) =>
    InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.0,
        ),
      ),
      // labelStyle: TextStyle(color: Colors.white),
      labelText: label,
      prefixText: prefix,
      errorText: errorText,
    );
