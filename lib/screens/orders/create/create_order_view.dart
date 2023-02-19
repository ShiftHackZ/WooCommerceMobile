
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/core/pair.dart';
import 'package:wooapp/extensions/extensions_product.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/screens/home/home.dart';
import 'package:wooapp/screens/orders/create/create_order_cubit.dart';
import 'package:wooapp/screens/orders/create/create_order_state.dart';
import 'package:wooapp/screens/orders/create/edit/edit_order_recipient.dart';
import 'package:wooapp/screens/orders/create/edit/edit_order_shipping.dart';
import 'package:wooapp/screens/orders/create/widgets/create_order_widget_payment.dart';
import 'package:wooapp/screens/orders/create/widgets/create_order_widget_shipping.dart';
import 'package:wooapp/screens/orders/create/widgets/create_order_widgets.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_custom_spacer.dart';
import 'package:wooapp/widget/widget_dialog.dart';
import 'package:wooapp/widget/widget_error_state.dart';

import 'model/create_order_model.dart';

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

  void _displayValidationErrors(
    BuildContext context,
    List<CreateOrderValidationError> errors,
  ) {
    String errorsString = '';
    for (var err in errors) {
      errorsString = '$errorsString\n${_parseValidationError(err)}';
    }
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
    child: WooErrorStateWidget(() => context.read<CreateOrderCubit>().getItems()),
  );

  Widget _contentState(
    BuildContext context,
    ContentCreateOrderState state,
  ) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreateOrderHeader(
                FaIcon(
                  FontAwesomeIcons.box,
                  color: WooAppTheme.colorCreateOrderHeaderText,
                ),
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: WooAppTheme.colorCardCreateOrderText,
                      ),
                    ).tr(),
                    DotSpacer(),
                    Text(
                      '${parseTotals(state.cart.totals.total)}'
                      '${WooAppConfig.currency}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: WooAppTheme.colorCardCreateOrderText,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
              CreateOrderHeader(
                FaIcon(
                  FontAwesomeIcons.truck,
                  color: WooAppTheme.colorCreateOrderHeaderText,
                ),
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
                FaIcon(
                  FontAwesomeIcons.wallet,
                  color: WooAppTheme.colorCreateOrderHeaderText,
                ),
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
                FaIcon(
                  FontAwesomeIcons.userLarge,
                  color: WooAppTheme.colorCreateOrderHeaderText,
                ),
                tr('create_order_person'),
                end: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xD000000))
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditOrderRecipientScreen(
                          recipient: state.recipient,
                          otherRecipient: state.otherRecipient,
                          isOther: state.isOtherRecipient,
                        ),
                      ),
                    ).then((result) {
                      if (result is Pair<CreateOrderRecipient, bool> == true) {
                        context.read<CreateOrderCubit>().onNewRecipient(
                          (result as  Pair<CreateOrderRecipient, bool>).first,
                          isOther: result.second,
                        );
                      }
                    });
                  },
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
                FaIcon(
                  FontAwesomeIcons.child,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_name'),
                state.isOtherRecipient
                    ? '${state.otherRecipient.firstName} ${state.otherRecipient.lastName}'
                    : '${state.recipient.firstName} ${state.recipient.lastName}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.phoneFlip,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_phone'),
                state.isOtherRecipient
                    ? '${state.otherRecipient.phone}'
                    : '${state.recipient.phone}',
                () {},
              ),
              SizedBox(height: 8),
              CreateOrderHeader(
                FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: WooAppTheme.colorCreateOrderHeaderText,
                ),
                tr('create_order_shipping'),
                end: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xD000000))
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditOrderShippingScreen(
                          shipping: state.shipping,
                          otherShipping: state.otherShipping,
                          isOther: state.isOtherShipping,
                        ),
                      ),
                    ).then((result) {
                      if (result is Pair<CreateOrderShipping, bool> == true) {
                        context.read<CreateOrderCubit>().onNewShipping(
                          (result as  Pair<CreateOrderShipping, bool>).first,
                          isOther: result.second,
                        );
                      }
                    });
                  },
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
                FaIcon(
                  FontAwesomeIcons.globe,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_country'),
                state.isOtherShipping
                    ? '${state.otherShipping.country}'
                    : '${state.shipping.country}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.map,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_state'),
                state.isOtherShipping
                    ? '${state.otherShipping.state}'
                    : '${state.shipping.state}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.road,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_city'),
                state.isOtherShipping
                    ? '${state.otherShipping.city}'
                    : '${state.shipping.city}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.locationArrow,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_post'),
                state.isOtherShipping
                    ? '${state.otherShipping.index}'
                    : '${state.shipping.index}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.building,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_address_1'),
                state.isOtherShipping
                    ? '${state.otherShipping.address1}'
                    : '${state.shipping.address1}',
                () {},
              ),
              CreateOrderSection(
                FaIcon(
                  FontAwesomeIcons.signsPost,
                  size: 20,
                  color: WooAppTheme.colorPrimaryBackground,
                ),
                tr('create_order_address_2'),
                state.isOtherShipping
                    ? '${state.otherShipping.address2}'
                    : '${state.shipping.address2}',
                () {},
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
                          checkColor: WooAppTheme.colorPrimaryForeground,
                          fillColor: MaterialStateProperty.all(
                            WooAppTheme.colorPrimaryBackground,
                          ),
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
                          style: TextStyle(
                            fontSize: 15,
                            color: WooAppTheme.colorCommonText,
                          ),
                        ).tr(),
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
                        FaIcon(
                          FontAwesomeIcons.check,
                          color: WooAppTheme.colorPrimaryForeground,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'cart_checkout_full',
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