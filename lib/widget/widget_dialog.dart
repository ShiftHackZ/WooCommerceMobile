import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

enum WooDialogType {
  text,
  widget;
}

class WooDialog extends StatefulWidget {
  final WooDialogType type;
  final String title;
  final String text;
  final String buttonPositiveText;
  //final String buttonNegativeText;
  final Widget? content;
  final Function? onPositiveButton;

  const WooDialog({
    this.type = WooDialogType.text,
    this.title = '',
    this.text = '',
    this.buttonPositiveText = 'OK',
    //this.buttonNegativeText = '',
    this.content,
    this.onPositiveButton,
  });

  @override
  _WooDialogState createState() => _WooDialogState();
}

class _WooDialogState extends State<WooDialog> {
  final double indentAvatar = 45;
  final double indentPadding = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(indentPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }
  
  Widget _contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: indentPadding,
            top: indentAvatar + indentPadding, 
            right: indentPadding,
            bottom: indentPadding,
          ),
          margin: EdgeInsets.only(top: indentAvatar),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: WooAppTheme.colorCommonBackground,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x4D000000),
                offset: Offset(0, indentPadding),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: WooAppTheme.colorCommonText,
                ),
              ),
              SizedBox(height: 15,),
              if (widget.type == WooDialogType.text) Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14,
                  color: WooAppTheme.colorCommonText,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.type == WooDialogType.widget) widget.content ?? Container(),
              SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      if (widget.onPositiveButton != null) {
                        widget.onPositiveButton!();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.buttonPositiveText.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        color: WooAppTheme.colorPrimaryBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: indentPadding,
          right: indentPadding,
          child: CircleAvatar(
            backgroundColor: WooAppTheme.colorPrimaryBackground,
            radius: indentAvatar,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(indentAvatar),
              ),
              child: Icon(
                Icons.error,
                size: 40,
                color: WooAppTheme.colorPrimaryForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
