import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/model/customer_profile.dart';
import 'package:wooapp/screens/profile/profile_state.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/screens/profile/profile_cubit.dart';

class ShippingEditView extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<ProfileCubit>().getProfile();
      },
      child: Scaffold(
        backgroundColor: WooAppTheme.colorCommonBackground,
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'shipping',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          backgroundColor: WooAppTheme.colorToolbarBackground,
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case CompleteProfileState:
                Navigator.pop(context, true);
                break;
            //ToDo ...
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case InitialProfileState:
                  return _loadingState();
                case LoadingProfileState:
                  return _loadingState();
                case ContentProfileState:
                  var currentState = (state as ContentProfileState);
                  _countryController.text = currentState.profile.shipping.country;
                  _cityController.text = currentState.profile.shipping.city;
                  _stateController.text = currentState.profile.shipping.state;
                  _postCodeController.text = currentState.profile.shipping.postcode;
                  _address1Controller.text = currentState.profile.shipping.address1;
                  _address2Controller.text = currentState.profile.shipping.address2;
                  return _contentState(context, currentState.profile);
                case ErrorProfileState:
                  return _errorState();
                case NoAuthProfileState:
                  return _errorState();
                default:
                  return _loadingState();
              }
            },
          ),
        ),
      )
  );

  Widget _contentState(BuildContext context, CustomerProfile profile) => Scaffold(
    backgroundColor: WooAppTheme.colorCommonBackground,
    bottomNavigationBar: Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              hideKeyboardForce(context);
              context.read<ProfileCubit>().updateShipping(
                _countryController.text,
                _cityController.text,
                _stateController.text,
                _postCodeController.text,
                _address1Controller.text,
                _address2Controller.text,
              );
            }
          },
          child: Text(
            'update_shipping',
            style: TextStyle(
              fontSize: 18,
              color: WooAppTheme.colorPrimaryForeground,
            ),
          ).tr(),
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
    ),
    body: SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _countryController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_country')),
                    // validator: (value) => !isEmail(value.toString()) ? 'Invalid E-Mail' : null
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _cityController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_city')),
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _stateController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_state')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _postCodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_post_code')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _address1Controller,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_address_1')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _address2Controller,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('shipping_address_2')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _loadingState() => Center(
    child: CircularProgressIndicator(
      strokeWidth: 1,
    ),
  );

  Widget _errorState() => Center(
    child: Text("Error"),
  );

  InputDecoration _decorate(String label, {String prefix = ''}) => InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0)
      ),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
      ),
      // labelStyle: TextStyle(color: Colors.white),
      labelText: label,
      prefixText: prefix
  );
}