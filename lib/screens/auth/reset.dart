import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/datasource/customer_auth_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/widget/widget_dialog.dart';
import 'package:wooapp/widget/widget_loader_full_screen.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final CustomerAuthDataSource _ds = locator<CustomerAuthDataSource>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _lController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _buildResetWidget(),
      if (_loading) WooFullScreenLoader(),
    ],
  );
  
  Widget _buildResetWidget() => Scaffold(
    appBar: AppBar(
      leading: BackButton(
        color: WooAppTheme.colorToolbarForeground,
      ),
      backgroundColor: WooAppTheme.colorAuthBackground,
      elevation: 0,
    ),
    backgroundColor: WooAppTheme.colorAuthBackground,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'password_recovery',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: WooAppTheme.colorAuthHeaderText,
                    ),
                    textAlign: TextAlign.center,
                  ).tr(),
                  SizedBox(height: 32),
                  TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _lController,
                    cursorColor: WooAppTheme.colorAuthFieldText,
                    style: TextStyle(
                      fontSize: 16,
                      color: WooAppTheme.colorAuthFieldText,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: WooAppTheme.colorAuthFieldText,
                          width: 0.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: WooAppTheme.colorAuthFieldText,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: WooAppTheme.colorAuthNotValidFieldText,
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: WooAppTheme.colorAuthNotValidFieldText,
                          width: 1.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: WooAppTheme.colorAuthFieldText,
                      ),
                      labelText: tr('username'),
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _reset();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          tr('reset').toUpperCase(),
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: WooAppTheme.colorAuthActionText,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          WooAppTheme.colorAuthActionBackground,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            side: BorderSide(
                              color: WooAppTheme.colorAuthActionBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'remember_password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: WooAppTheme.colorAuthHeaderText,
                        ),
                      ).tr(),
                      SizedBox(width: 6),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'sign_in_footer',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: WooAppTheme.colorAuthActionText,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _reset() async {
    _onStartLoading();
    _ds.reset(
        _lController.text.toString().trim(),
    ).then((register) {
      _onFinalizeLoading();
      Navigator.of(context).pop();
      _showResult(tr('success'), tr('reset_success'));
    }).catchError((error) {
      _onFinalizeLoading();
      _showResult(tr('error'), tr('error_user_not_exist'));
    });
  }

  void _onStartLoading() {
    hideKeyboardForce(context);
    setState(() {
      _loading = true;
    });
  }

  void _onFinalizeLoading() => setState(() {
    _loading = false;
  });

  void _showResult(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => WooDialog(
        title: title,
        text: desc,
      ),
    );
  }
}