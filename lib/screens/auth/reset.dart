import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/datasource/customer_auth_data_source.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/widget/widget_diaolg.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final CustomerAuthDataSource _ds = locator<CustomerAuthDataSource>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _lController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
    ),
    backgroundColor: Colors.blue,
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
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ).tr(),
                  SizedBox(height: 32),
                  TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _lController,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 0.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0)
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: tr('username'),

                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      }
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
                              color: Colors.blue,
                              letterSpacing: 2.0
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                              side: BorderSide(color: Colors.white)
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
                            color: Colors.white
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
                              color: Colors.white
                          ),
                        ).tr(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _reset() async {
    _ds.reset(
        _lController.text.toString().trim(),
    ).then((register) {
      Navigator.of(context).pop();
      showResult(tr('success'), tr('reset_success'));
    }).catchError((error) {
      showResult(tr('error'), tr('error_user_not_exist'));
    });
  }

  void showResult(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogBox(
        title: title,
        descriptions: desc,
      ),
    );
  }
}