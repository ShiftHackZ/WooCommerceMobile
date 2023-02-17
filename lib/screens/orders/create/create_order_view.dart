
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/screens/home/home.dart';
import 'package:wooapp/screens/orders/create/create_order_cubit.dart';
import 'package:wooapp/screens/orders/create/create_order_state.dart';
import 'package:wooapp/screens/orders/create/create_order_widget_payment.dart';
import 'package:wooapp/screens/orders/create/create_order_widget_shipping.dart';
import 'package:wooapp/screens/orders/create/create_order_widgets.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_custom_spacer.dart';
import 'package:wooapp/widget/widget_dialog.dart';
import 'package:wooapp/widget/widget_retry.dart';

import 'create_order_model.dart';

class CreateOrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<CreateOrderCubit>().getItems();
      },
      child: Scaffold(
        backgroundColor: WooAppTheme.colorCommonBackground,
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'create_order_title',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          backgroundColor: WooAppTheme.colorToolbarBackground,
        ),
        body: SafeArea(
          child: BlocListener<CreateOrderCubit, CreateOrderState>(
            listener: (context, state) {
              switch (state.runtimeType) {
                case CompleteCreateOrderState:
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                  _displayCheckoutSuccess(context, (state as CompleteCreateOrderState).order);
                  break;
                case InvalidCreateOrderState:
                  _displayValidationErrors(context, (state as InvalidCreateOrderState).errors);
                  break;
              }
            },
            child: BlocBuilder<CreateOrderCubit, CreateOrderState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case InitialCreateOrderState:
                    return _loadingState();
                  case LoadingCreateOrderState:
                    return _loadingState();
                  case ErrorCreateOrderState:
                    return _errorState(context);
                  case ContentCreateOrderState:
                    return _contentState(
                      context,
                      (state as ContentCreateOrderState),
                    );
                  default:
                    return _loadingState();
                }
              },
            ),
          ),
        ),
      ),
  );

  void _displayCheckoutSuccess(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => WooDialog(
        title: 'Success',
        text: 'Order #${order.id} created successfully',
      ),
    );
  }

  void _displayValidationErrors(BuildContext context, List<CreateOrderValidationError> errors) {
    String errorsString = '';
    for (var err in errors) errorsString = '$errorsString\n${_parseValidationError(err)}';

    showDialog(
      context: context,
      builder: (ctx) => WooDialog(
        title: 'Validation errors',
        text: errorsString,
      ),
    );
    context.read<CreateOrderCubit>().invalidate();
  }

  String _parseValidationError(CreateOrderValidationError error) {
    switch (error) {
      case CreateOrderValidationError.ADDRESS_EMPTY:
        return 'addres is empty';
      case CreateOrderValidationError.RECIPIENT_EMPTY:
        return 'recipient empty';
      case CreateOrderValidationError.TERMS_NOT_ACCEPTED:
        return 'terms not accepted';
    }
  }

  Widget _loadingState() => Center(
    child: Lottie.asset('assets/checkout_loader.json'),
  );

  Widget _errorState(BuildContext context) => Container(
    child: ErrorRetryWidget(() => context.read<CreateOrderCubit>().getItems()),
  );

  Widget _contentState(
      BuildContext context,
      ContentCreateOrderState state
  ) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreateOrderHeader(
                FaIcon(FontAwesomeIcons.box),
                tr('create_order_products')
              ),
              SizedBox(height: 8),
              for (var item in state.cart.items) CreateOrderProduct(item),
              Container(
                margin: EdgeInsets.only(top: 8, left: 14, right: 18),
                child: Row(
                  children: [
                    Text(
                      'create_order_totals',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ).tr(),
                    DotSpacer(),
                    Text(
                      '${state.cart.totals.total}${WooAppConfig.currency}',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
              CreateOrderHeader(
                FaIcon(FontAwesomeIcons.truck),
                tr('create_order_shipping_method'),
              ),
              SizedBox(height: 8),
              CreateOrderShippingWidget(
                state.selectedShippingIndex,
                state.shippingMethods,
                (shippingIndex) => context
                    .read<CreateOrderCubit>()
                    .onShippingSelected(shippingIndex),
              ),
              CreateOrderHeader(
                FaIcon(FontAwesomeIcons.wallet),
                tr('create_order_payment_method'),
              ),
              SizedBox(height: 8),
              CreateOrderPaymentWidget(
                state.selectedPaymentIndex,
                state.paymentMethods,
                (paymentIndex) => context
                    .read<CreateOrderCubit>()
                    .onPaymentSelected(paymentIndex),
              ),

              SizedBox(height: 8),
              CreateOrderHeader(
                FaIcon(FontAwesomeIcons.userAlt),
                tr('create_order_person'),
                end: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xD000000))
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'edit',
                        style: TextStyle(
                          color: WooAppTheme.colorPrimaryBackground,
                        ),
                      ).tr(),
                      SizedBox(width: 8),
                      FaIcon(
                        FontAwesomeIcons.pen,
                        color: WooAppTheme.colorPrimaryBackground,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              CreateOrderSection(
                FaIcon(FontAwesomeIcons.child, size: 20,),
                tr('create_order_name'),
                '${state.recipient.firstName} ${state.recipient.lastName}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(FontAwesomeIcons.phoneAlt, size: 20,),
                tr('create_order_phone'),
                '${state.recipient.phone}',
                () {},
              ),
              SizedBox(height: 8),
              CreateOrderHeader(
                FaIcon(FontAwesomeIcons.mapMarkerAlt),
                tr('create_order_shipping'),
                end: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xD000000))
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'edit',
                        style: TextStyle(
                          color: WooAppTheme.colorPrimaryBackground,
                        ),
                      ).tr(),
                      SizedBox(width: 8),
                      FaIcon(
                        FontAwesomeIcons.pen,
                        color: WooAppTheme.colorPrimaryBackground,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.globe, size: 20,),
                  tr('create_order_country'),
                  '${state.shipping.country}',
                  () {}
              ),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.map, size: 20,),
                  tr('create_order_state'),
                  '${state.shipping.state}',
                      () {}
              ),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.road, size: 20,),
                  tr('create_order_city'),
                  '${state.shipping.city}',
                      () {}
              ),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.locationArrow, size: 20,),
                  tr('create_order_post'),
                  '${state.shipping.index}',
                      () {}
              ),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.building, size: 20,),
                  tr('create_order_address_1'),
                  '${state.shipping.address1}',
                      () {}
              ),
              CreateOrderSection(
                  FaIcon(FontAwesomeIcons.mapSigns, size: 20,),
                  tr('create_order_address_2'),
                  '${state.shipping.address2}',
                      () {}
              ),

              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: GestureDetector(
                  onTap: () => context
                      .read<CreateOrderCubit>()
                      .onChangeTermsAccepted(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 4),
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all(Colors.deepPurple),
                          value: state.termsAccepted,
                          shape: CircleBorder(),
                          onChanged: (value) => context
                              .read<CreateOrderCubit>()
                              .onChangeTermsAccepted()
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'create_order_terms',
                          style: TextStyle(fontSize: 15)
                        ).tr()
                      ),
                    ],
                  ),
                ),
              ),


              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  top: 8,
                ),
                child: ElevatedButton(
                  onPressed: () => context
                      .read<CreateOrderCubit>()
                      .createOrder(),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.check),
                        SizedBox(width: 8),
                        Text(
                          'cart_checkout_full',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
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
                        side: BorderSide(
                          color: WooAppTheme.colorPrimaryBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}