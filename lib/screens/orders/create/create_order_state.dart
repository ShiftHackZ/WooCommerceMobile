import 'package:wooapp/model/cart_response.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/model/payment_method.dart';
import 'package:wooapp/model/shipping_method.dart';
import 'package:wooapp/screens/orders/create/model/create_order_model.dart';

abstract class CreateOrderState {}

class InitialCreateOrderState extends CreateOrderState {}

class LoadingCreateOrderState extends CreateOrderState {}

class ErrorCreateOrderState extends CreateOrderState {}

class ContentCreateOrderState extends CreateOrderState {
  CartResponse cart;
  CreateOrderRecipient recipient;
  CreateOrderRecipient otherRecipient;
  bool isOtherRecipient;
  CreateOrderShipping shipping;
  List<ShippingMethod> shippingMethods;
  List<PaymentMethod> paymentMethods;

  int selectedShippingIndex;
  int selectedPaymentIndex;

  bool termsAccepted;

  ContentCreateOrderState(
    this.cart,
    this.recipient,
    this.otherRecipient,
    this.isOtherRecipient,
    this.shipping,
    this.shippingMethods,
    this.paymentMethods,
    this.selectedShippingIndex,
    this.selectedPaymentIndex,
    this.termsAccepted,
  );
}

class InvalidCreateOrderState extends CreateOrderState {
  List<CreateOrderValidationError> errors;

  InvalidCreateOrderState(this.errors);
}

class CompleteCreateOrderState extends CreateOrderState {
  Order order;

  CompleteCreateOrderState(this.order);
}