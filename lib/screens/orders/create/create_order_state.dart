import 'package:untitled/model/cart_response.dart';
import 'package:untitled/model/order.dart';
import 'package:untitled/model/payment_method.dart';
import 'package:untitled/model/shipping_method.dart';
import 'package:untitled/screens/orders/create/create_order_model.dart';

abstract class CreateOrderState {}

class InitialCreateOrderState extends CreateOrderState {}

class LoadingCreateOrderState extends CreateOrderState {}

class ErrorCreateOrderState extends CreateOrderState {}

class ContentCreateOrderState extends CreateOrderState {
  CartResponse cart;
  CreateOrderRecipient recipient;
  CreateOrderShipping shipping;
  List<ShippingMethod> shippingMethods;
  List<PaymentMethod> paymentMethods;

  int selectedShippingIndex;
  int selectedPaymentIndex;

  bool termsAccepted;

  ContentCreateOrderState(
      this.cart,
      this.recipient,
      this.shipping,
      this.shippingMethods,
      this.paymentMethods,
      this.selectedShippingIndex,
      this.selectedPaymentIndex,
      this.termsAccepted
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