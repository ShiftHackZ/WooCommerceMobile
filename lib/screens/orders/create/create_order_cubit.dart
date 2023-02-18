import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/datasource/cart_data_source.dart';
import 'package:wooapp/datasource/customer_profile_data_source.dart';
import 'package:wooapp/datasource/orders_create_data_source.dart';
import 'package:wooapp/datasource/payment_methods_data_source.dart';
import 'package:wooapp/datasource/shipping_method_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/cart_response.dart';
import 'package:wooapp/model/customer_profile.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/model/payment_method.dart';
import 'package:wooapp/model/shipping_method.dart';
import 'package:wooapp/screens/orders/create/model/create_order_model.dart';
import 'package:wooapp/screens/orders/create/create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CartDataSource _cart = locator<CartDataSource>();
  final CustomerProfileDataSource _profile = locator<CustomerProfileDataSource>();
  final ShippingMethodDataSource _shipping = locator<ShippingMethodDataSource>();
  final PaymentMethodDataSource _payment = locator<PaymentMethodDataSource>();
  final CreateOrderDataSource _create = locator<CreateOrderDataSource>();

  bool _orderTermsAccepted = false;
  int _dataShippingIndex = -1;
  int _dataPaymentIndex = -1;
  CartResponse _dataCart = CartResponse.empty();
  CreateOrderRecipient _dataRecipient = CreateOrderRecipient.empty();
  CreateOrderRecipient _dataRecipientOther = CreateOrderRecipient.empty();
  bool _isRecipientOther = false;
  CreateOrderShipping _dataShipping = CreateOrderShipping.empty();
  CreateOrderShipping _dataShippingOther = CreateOrderShipping.empty();
  bool _isShippingOther = false;
  List<ShippingMethod> _dataShippingMethods = [];
  List<PaymentMethod> _dataPaymentMethods = [];

  CreateOrderCubit() : super(InitialCreateOrderState());

  void getItems() {
    Future.wait([
      _cart.getCart(),
      _profile.getProfile(),
      _shipping.getShippingMethods(),
      _payment.getPaymentMethods(),
    ]).then((List<dynamic> data) {
      if (_dataShippingIndex == -1) _dataShippingIndex = 0;
      if (_dataPaymentIndex == -1) _dataPaymentIndex = 0;
      _dataCart = data[0] as CartResponse;
      _dataRecipient = CreateOrderRecipient(
        (data[1] as CustomerProfile).firstName,
        (data[1] as CustomerProfile).lastName,
        (data[1] as CustomerProfile).billing.phone,
        (data[1] as CustomerProfile).billing.email,
      );
      _dataShipping = CreateOrderShipping(
        (data[1] as CustomerProfile).shipping.country,
        (data[1] as CustomerProfile).shipping.state,
        (data[1] as CustomerProfile).shipping.city,
        (data[1] as CustomerProfile).shipping.postcode,
        (data[1] as CustomerProfile).shipping.address1,
        (data[1] as CustomerProfile).shipping.address2,
      );
      _dataShippingMethods = data[2] as List<ShippingMethod>;
      _dataPaymentMethods = (data[3] as List<PaymentMethod>)
        ..removeWhere((method) => method.enabled == false);

      invalidate();
    }).catchError((error, stacktrace) {
      Completer().completeError(error, stacktrace);
      emit(ErrorCreateOrderState());
    });
  }

  void invalidate() {
    emit(
      ContentCreateOrderState(
        _dataCart,
        _dataRecipient,
        _dataRecipientOther,
        _isRecipientOther,
        _dataShipping,
        _dataShippingOther,
        _isShippingOther,
        _dataShippingMethods,
        _dataPaymentMethods,
        _dataShippingIndex,
        _dataPaymentIndex,
        _orderTermsAccepted,
      ),
    );
  }

  List<CreateOrderValidationError> validate() {
    List<CreateOrderValidationError> result = [];
    if (!_orderTermsAccepted) {
      result.add(CreateOrderValidationError.TERMS_NOT_ACCEPTED);
    }
    return result;
  }

  void createOrder() {
    var validation = validate();
    if (validation.isNotEmpty) {
      emit(InvalidCreateOrderState(validation));
    } else {
      emit(LoadingCreateOrderState());
      Future.wait([
        _create.createOrder(
          _dataCart.items,
          _isRecipientOther ? _dataRecipientOther : _dataRecipient,
          _isShippingOther ? _dataShippingOther : _dataShipping,
          _dataShippingMethods[_dataShippingIndex],
          _dataPaymentMethods[_dataPaymentIndex],
        ),
        _cart.clearCart()
      ]).then((data) {
        emit(CompleteCreateOrderState(data[0] as Order));
      }).catchError((error) {
        print('Create order error: $error');
      });
    }
  }

  void onChangeTermsAccepted() {
    _orderTermsAccepted = !_orderTermsAccepted;
    invalidate();
  }

  void onShippingSelected(int index) {
    _dataShippingIndex = index;
    invalidate();
  }

  void onPaymentSelected(int index) {
    _dataPaymentIndex = index;
    invalidate();
  }

  void onNewRecipient(
    CreateOrderRecipient recipient, {
    bool isOther = false,
  }) {
    _isRecipientOther = isOther;
    if (isOther) {
      _dataRecipientOther = recipient;
    } else {
      _dataRecipient = recipient;
    }
    invalidate();
  }

  void onNewShipping(
    CreateOrderShipping shipping, {
    bool isOther = false,
  }) {
    _isShippingOther = isOther;
    if (isOther) {
      _dataShippingOther = shipping;
    } else {
      _dataShipping = shipping;
    }
    invalidate();
  }
}
