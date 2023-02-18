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

class EditOrderRecipientScreen extends StatefulWidget {
  final CreateOrderRecipient recipient;
  final CreateOrderRecipient otherRecipient;
  final bool isOther;

  final CustomerProfileDataSource _ds = locator<CustomerProfileDataSource>();

  EditOrderRecipientScreen({
    required this.recipient,
    this.otherRecipient = const CreateOrderRecipient.empty(),
    this.isOther = false,
  });

  @override
  State<StatefulWidget> createState() => _EditOrderRecipientScreenState();
}

class _EditOrderRecipientScreenState extends State<EditOrderRecipientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _otherFirstNameController =
      TextEditingController();
  final TextEditingController _otherLastNameController =
      TextEditingController();
  final TextEditingController _otherPhoneNumberController =
      TextEditingController();

  bool _isOtherRecipient = false;
  bool _loading = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;

  @override
  void initState() {
    _firstNameController.text = widget.recipient.firstName;
    _lastNameController.text = widget.recipient.lastName;
    _phoneController.text = widget.recipient.phone;
    _otherFirstNameController.text = widget.otherRecipient.firstName;
    _otherLastNameController.text = widget.otherRecipient.lastName;
    _otherPhoneNumberController.text = widget.otherRecipient.phone;
    setState(() {
      _isOtherRecipient = widget.isOther;
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
            'create_order_person',
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
                    FontAwesomeIcons.userLarge,
                    color: WooAppTheme.colorCreateOrderHeaderText,
                  ),
                  // tr('create_order_payment_method'),
                  'Оберіть хто буде отримувати замовлення',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: _buildRecipientTypeSelector(),
                ),
                CreateOrderHeader(
                  FaIcon(
                    FontAwesomeIcons.passport,
                    color: WooAppTheme.colorCreateOrderHeaderText,
                  ),
                  // tr('create_order_payment_method'),
                  'Персональні дані отримувача',
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
              var validPredicate = _firstNameError == null &&
                  _lastNameError == null &&
                  _phoneError == null;
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

  Widget _buildRecipientTypeSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRecipientTypeCard(
            action: () => setState(() {
              _firstNameError = null;
              _lastNameError = null;
              _phoneError = null;
              _isOtherRecipient = false;
            }),
          ),
          _buildRecipientTypeCard(
            isOtherRecipient: true,
            action: () => setState(() {
              _firstNameError = null;
              _lastNameError = null;
              _phoneError = null;
              _isOtherRecipient = true;
            }),
          ),
        ],
      );

  Widget _buildRecipientTypeCard({
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
                color: _isOtherRecipient == isOtherRecipient
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
                        ? FontAwesomeIcons.peopleCarryBox
                        : FontAwesomeIcons.personCircleCheck,
                    size: 40,
                    color: _isOtherRecipient == isOtherRecipient
                        ? WooAppTheme.colorPrimaryBackground
                        : WooAppTheme.colorCardCreateOrderText.withOpacity(0.7),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    isOtherRecipient ? 'Other' : 'me',
                    style: TextStyle(
                      fontSize:
                          _isOtherRecipient == isOtherRecipient ? 18.5 : 18,
                      fontWeight: _isOtherRecipient == isOtherRecipient
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: _isOtherRecipient == isOtherRecipient
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
              controller: _isOtherRecipient
                  ? _otherFirstNameController
                  : _firstNameController,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(tr('first_name'),
                  errorText: _firstNameError),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _firstNameError = 'First name is required');
                  return null;
                }
                setState(() => _firstNameError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              controller: _isOtherRecipient
                  ? _otherLastNameController
                  : _lastNameController,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: decorateTextFormField(
                tr('last_name'),
                errorText: _lastNameError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _lastNameError = 'Last name is required');
                  return null;
                }
                setState(() => _lastNameError = null);
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller:
                  _isOtherRecipient ? _otherPhoneNumberController : _phoneController,
              style: TextStyle(
                fontSize: 16,
              ),
              maxLength: 12,
              decoration: decorateTextFormField(
                tr('phone'),
                prefix: '+',
                errorText: _phoneError,
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  setState(() => _phoneError = 'Phone is required');
                  return null;
                }
                setState(() => _phoneError = null);
                return null;
              },
            ),
          ],
        ),
      );

  void _executeSubmission() async {
    CreateOrderRecipient recipient;
    if (_isOtherRecipient) {
      recipient = CreateOrderRecipient(
        _otherFirstNameController.text,
        _otherLastNameController.text,
        _otherPhoneNumberController.text,
        widget.recipient.email,
      );
    } else {
      recipient = CreateOrderRecipient(
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
        widget.recipient.email,
      );
      if (widget.recipient != recipient) {
        setState(() => _loading = true);
        await widget._ds.updateProfile(
          widget.recipient.email,
          _firstNameController.text,
          _lastNameController.text,
          _phoneController.text,
        );
        setState(() => _loading = false);
      }
    }
    Navigator.pop(context, Pair(recipient, _isOtherRecipient));
  }
}
