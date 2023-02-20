import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wooapp/config/theme.dart';

/// According to WooApp license agreement,
/// every fork that is based on this app should contain
/// this original copyright UI section.
class WooVersionWidget extends StatefulWidget {
  final WooVersionDisplayMode displayMode;

  WooVersionWidget({this.displayMode = WooVersionDisplayMode.singleLine});

  @override
  State<StatefulWidget> createState() => _WooVersionWidgetState();
}

class _WooVersionWidgetState extends State<WooVersionWidget> {
  static const _copyrightOwner = 'Dmitriy Moroz';
  static const _copyrightWebSite = 'https://dmitriy.moroz.cc/';

  String _appName = '';
  String _appVersion = '';
  String _appCopyright = '';

  @override
  void initState() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _appName = packageInfo.appName;
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        _appCopyright = '© ${DateTime.now().year} $_copyrightOwner';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildAppDetails(),
          SizedBox(height: 6),
          GestureDetector(
            onTap: () => launchUrl(
              Uri.parse(_copyrightWebSite),
              mode: LaunchMode.externalApplication,
            ),
            child: Text(
              _appCopyright,
              style: TextStyle(
                color: WooAppTheme.colorCommonSectionForeground,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );

  Widget _buildAppDetails() {
    switch (widget.displayMode) {
      case WooVersionDisplayMode.multiLine:
        return Column(
          children: [
            _buildAppName(),
            SizedBox(height: 2),
            _buildAppVersion(),
          ],
        );
      case WooVersionDisplayMode.singleLine:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAppName(),
            _buildHorizontalDivider(),
            _buildAppVersion(),
          ],
        );
    }
  }

  Widget _buildHorizontalDivider() => Text(
        ' — ',
        style: TextStyle(
          color: WooAppTheme.colorCommonText,
        ),
      );

  Widget _buildAppName() => Text(
        _appName,
        style: TextStyle(
          color: WooAppTheme.colorCommonText,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _buildAppVersion() => Text(
        _appVersion,
        style: TextStyle(
          color: WooAppTheme.colorCommonText,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      );
}

enum WooVersionDisplayMode {
  singleLine,
  multiLine;
}
