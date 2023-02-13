import 'package:untitled/model/cart_response.dart';

abstract class CartState {}

class InitialCartState extends CartState {}

class LoadingCartState extends CartState {}

class ContentCartState extends CartState {
  final CartResponse cart;

  ContentCartState(this.cart);
}

class EmptyCartState extends CartState {}

class ErrorCartState extends CartState {}

class NoAuthCartState extends CartState {}