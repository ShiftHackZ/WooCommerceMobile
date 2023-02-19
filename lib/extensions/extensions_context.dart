import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/widget/widget_bottom_sheet_builder.dart';

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

void hideKeyboardForce(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void showWooBottomSheet(BuildContext context, Widget child) {
  hideKeyboardForce(context);
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    context: context,
    isScrollControlled: true,
    backgroundColor: WooAppTheme.colorCommonBackground,
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

void showWooScrollableBottomSheet(
  BuildContext context, {
  required Widget Function(ScrollController) builder,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.85,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: WooAppTheme.colorCommonBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    BottomSheetHeading(),
                    Expanded(
                      child: builder(controller),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
