import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/datasource/customer_auth_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/auth/register.dart';
import 'package:wooapp/screens/auth/reset.dart';
import 'package:wooapp/widget/widget_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final CustomerAuthDataSource _ds = locator<CustomerAuthDataSource>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _lController = TextEditingController();
  final TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: WooAppTheme.colorAuthBackground,
      leading: IconButton(
        icon: Icon(
          CupertinoIcons.clear,
          color: WooAppTheme.colorToolbarForeground,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
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
                    'sign_in',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: WooAppTheme.colorAuthHeaderText,
                    ),
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
                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _pController,
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
                      labelText: tr('password'),
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PasswordRecoveryScreen())
                          );
                        },
                        child: Text(
                          tr('forgot_credentials'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: WooAppTheme.colorAuthActionText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          auth();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          tr('login').toUpperCase(),
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: WooAppTheme.colorPrimaryForeground,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          WooAppTheme.colorPrimaryBackground,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            side: BorderSide(
                              color: WooAppTheme.colorPrimaryBackground,
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
                        'have_no_account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: WooAppTheme.colorCommonText,
                        ),
                      ).tr(),
                      SizedBox(width: 6),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        ),
                        child: Text(
                          'sign_up_footer',
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

  Future<void> auth() async {
    _ds.login(
      _lController.text.toString().trim(),
      _pController.text.toString()
    ).then((data) {
      Navigator.pop(context, true);
    }).catchError((error) {
      if (error is DioError) {
        var message = error.response!.data['message'];
        showResult(tr('error'), message);
      }
    });
  }

  void showResult(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => WooDialog(
        title: title,
        text: desc,
      ),
    );
  }
}