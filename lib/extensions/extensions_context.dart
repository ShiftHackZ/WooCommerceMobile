import 'package:flutter/material.dart';
import 'package:untitled/widget/widget_bottom_sheet_builder.dart';

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

void hideKeyboardForce(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void showBottomOptions(BuildContext context, Widget child) {
  hideKeyboardForce(context);
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        BottomSheetHeading(),
        child,
        SizedBox(height: 8),
      ],
    ),
  );
}
