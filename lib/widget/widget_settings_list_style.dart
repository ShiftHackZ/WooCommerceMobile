import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

class ListStyleWidget extends StatefulWidget {
  final bool displayGrid;
  final ValueSetter<bool> callback;

  ListStyleWidget({
    required this.displayGrid,
    required this.callback,
  });

  @override
  State<StatefulWidget> createState() => _ListStyleWidgetState();
}

class _ListStyleWidgetState extends State<ListStyleWidget> {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(bottom: 8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (_, index) => _item(index == 0),
        ),
      );

  Widget _item(bool value) => GestureDetector(
        onTap: () {
          widget.callback(value);
          Navigator.of(context).pop();
        },
        child: Container(
          margin: EdgeInsets.only(top: 8, right: 16, left: 16),
          decoration: BoxDecoration(
            color: WooAppTheme.colorCommonSectionBackground,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 6, right: 16, top: 12, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  margin: EdgeInsets.only(left: 0, right: 4),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.list,
                      color: WooAppTheme.colorCommonSectionForeground,
                    ),
                  ),
                ),
                Text(
                  value ? 'list_style_grid' : 'list_style_default',
                  style: TextStyle(
                    fontSize: widget.displayGrid == value ? 18 : 17,
                    fontWeight: widget.displayGrid == value
                        ? FontWeight.w800
                        : FontWeight.w400,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                ).tr(),
                Spacer(),
                if (widget.displayGrid == value)
                  Icon(
                    Icons.check,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
              ],
            ),
          ),
        ),
      );
}
