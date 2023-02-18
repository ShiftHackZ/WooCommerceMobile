import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/core/pair.dart';
import 'package:wooapp/datasource/customer_profile_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/orders/create/model/create_order_model.dart';
import 'package:wooapp/screens/orders/create/widgets/create_order_widgets.dart';
import 'package:wooapp/widget/input_field_decorator.dart';
import 'package:wooapp/widget/widget_loader_full_screen.dart';

class EditOrderShippingScreen extends StatefulWidget {
  final CreateOrderShipping shipping;
  final CreateOrderShipping otherShipping;
  final bool isOther;

  final CustomerProfileDataSource _ds = locator<CustomerProfileDataSource>();

  EditOrderShippingScreen({
    required this.shipping,
    this.otherShipping = const CreateOrderShipping.empty(),
    this.isOther = false,
  });

  @override
  State<StatefulWidget> createState() => _EditOrderShippingScreenState();
}

class _EditOrderShippingScreenState extends State<EditOrderShippingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();

  final TextEditingController _otherCountryController = TextEditingController();
  final TextEditingController _otherCityController = TextEditingController();
  final TextEditingController _otherStateController = TextEditingController();
  final TextEditingController _otherPostCodeController =
      TextEditingController();
  final TextEditingController _otherAddress1Controller =
      TextEditingController();
  final TextEditingController _otherAddress2Controller =
      TextEditingController();

  bool _isOtherShipping = false;
  bool _loading = false;

  String? _countryError;
  String? _cityError;
  String? _stateError;
  String? _postCodeError;
  String? _address1Error;
  String? _address2Error;

  @override
  void initState() {
    _countryController.text = widget.shipping.country;
    _cityController.text = widget.shipping.city;
    _stateController.text = widget.shipping.state;
    _postCodeController.text = widget.shipping.index;
    _address1Controller.text = widget.shipping.address1;
    _address2Controller.text = widget.shipping.address2;

    _otherCountryController.text = widget.otherShipping.country;
    _otherCityController.text = widget.otherShipping.city;
    _otherStateController.text = widget.otherShipping.state;
    _otherPostCodeController.text = widget.otherShipping.index;
    _otherAddress1Controller.text = widget.otherShipping.address1;
    _otherAddress2Controller.text = widget.otherShipping.address2;
    setState(() {
      _isOtherShipping = widget.isOther;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          _buildScreenContent(),
          if (_loading) WooFullScreenLoader(),
        ],
      );

  Widget _buildScreenContent() => Scaffold(
        bottomNavigationBar: _buildBottomActionBar(),
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'create_order_shipping',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          backgroundColor: WooAppTheme.colorToolbarBackground,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreateOrderHeader(
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    color: WooAppTheme.colorCreateOrderHeaderText,
                  ),
                  // tr('create_order_payment_method'),
                  'Оберіть куди потрібно доставити ваше замовлення',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: _buildShippingTypeSelector(),
                ),
                CreateOrderHeader(
                  FaIcon(
                    FontAwesomeIcons.compass,
                    color: WooAppTheme.colorCreateOrderHeaderText,
                  ),
                  // tr('create_order_payment_method'),
                  'Детальне місцезнаходження',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  child: _buildRecipientDataForm(),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBottomActionBar() => Container(
        height: 60,
        child: Padding(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: ElevatedButton(
            onPressed: () {
              _formKey.currentState!.validate();
              hideKeyboardForce(context);
              var validPredicate = _countryError == null &&
                  _cityError == null &&
                  _stateError == null &&
                  _postCodeError == null &&
                  _address1Error == null &&
                  _address2Error == null;
              if (validPredicate) {
                print('FORM VALID');
                _executeSubmission();
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.check,
                    color: WooAppTheme.colorPrimaryForeground,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Зберегти',
                    style: TextStyle(
                      fontSize: 18,
                      color: WooAppTheme.colorPrimaryForeground,
                    ),
                  ).tr(),
                ],
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                WooAppTheme.colorPrimaryBackground,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                  side: BorderSide(color: WooAppTheme.colorPrimaryBackground),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildShippingTypeSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShippingTypeCard(
            action: () => setState(() {
              _clearValidationErrors();
              _isOtherShipping = false;
            }),
          ),
          _buildShippingTypeCard(
            isOtherRecipient: true,
            action: () => setState(() {
              _clearValidationErrors();
              _isOtherShipping = true;
            }),
          ),
        ],
      );

  Widget _buildShippingTypeCard({
    required VoidCallback action,
    bool isOtherRecipient = false,
  }) =>
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 120,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0),
              side: BorderSide(
                width: 2.0,
                color: _isOtherShipping == isOtherRecipient
                    ? WooAppTheme.colorPrimaryBackground
                    : WooAppTheme.colorCardCreateOrderBackground,
              ),
            ),
            elevation: 0,
            color: WooAppTheme.colorCardCreateOrderBackground,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: action,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    isOtherRecipient
                        ? FontAwesomeIcons.building
                        : FontAwesomeIcons.houseUser,
                    size: 40,
                    color: _isOtherShipping == isOtherRecipient
                        ? WooAppTheme.colorPrimaryBackground
                        : WooAppTheme.colorCardCreateOrderText.withOpacity(0.7),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    isOtherRecipient ? 'Інша адреса' : 'Моя адреса',
                    style: TextStyle(
                      fontSize:
                          _isOtherShipping == isOtherRecipient ? 18.5 : 18,
                      fontWeight: _isOtherShipping == isOtherRecipient
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: _isOtherShipping == isOtherRecipient
                          ? WooAppTheme.colorPrimaryBackground
                          : WooAppTheme.colorCardCreateOrderText
                              .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildRecipientDataForm() => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller: _isOtherShipping
                  ? _otherCountryController
                  : _countryController,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_country'),
                errorText: _countryError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _countryError = 'Country is required');
                  return null;
                }
                setState(() => _countryError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller:
                  _isOtherShipping ? _otherCityController : _cityController,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_city'),
                errorText: _cityError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _cityError = 'City is required');
                  return null;
                }
                setState(() => _cityError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller:
                  _isOtherShipping ? _otherStateController : _stateController,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_state'),
                errorText: _stateError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _stateError = 'State is required');
                  return null;
                }
                setState(() => _stateError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller: _isOtherShipping
                  ? _otherPostCodeController
                  : _postCodeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_post_code'),
                errorText: _postCodeError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _postCodeError = 'Post code is required');
                  return null;
                }
                setState(() => _postCodeError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller: _isOtherShipping
                  ? _otherAddress1Controller
                  : _address1Controller,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_address_1'),
                errorText: _address1Error,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _address1Error = 'Address is required');
                  return null;
                }
                setState(() => _address1Error = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller: _isOtherShipping
                  ? _otherAddress2Controller
                  : _address2Controller,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('shipping_address_2'),
                errorText: _address2Error,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _address2Error = 'Address is required');
                  return null;
                }
                setState(() => _address2Error = null);
                return null;
              },
            ),
          ],
        ),
      );

  void _clearValidationErrors() => setState(() {
        _countryError = null;
        _cityError = null;
        _stateError = null;
        _postCodeError = null;
        _address1Error = null;
        _address2Error = null;
      });

  void _executeSubmission() async {
    CreateOrderShipping shipping;
    if (_isOtherShipping) {
      shipping = CreateOrderShipping(
        _otherCountryController.text,
        _otherStateController.text,
        _otherCityController.text,
        _otherPostCodeController.text,
        _otherAddress1Controller.text,
        _otherAddress2Controller.text,
      );
    } else {
      shipping = CreateOrderShipping(
        _countryController.text,
        _stateController.text,
        _cityController.text,
        _postCodeController.text,
        _address1Controller.text,
        _address2Controller.text,
      );
      if (widget.shipping != shipping) {
        setState(() => _loading = true);
        await widget._ds.updateShipping(
          _countryController.text,
          _stateController.text,
          _cityController.text,
          _postCodeController.text,
          _address1Controller.text,
          _address2Controller.text,
        );
        setState(() => _loading = false);
      }
    }
    Navigator.pop(context, Pair(shipping, _isOtherShipping));
  }
}
