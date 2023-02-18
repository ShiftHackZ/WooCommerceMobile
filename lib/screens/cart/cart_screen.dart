import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/cart/cart_cubit.dart';
import 'package:wooapp/screens/cart/cart_view.dart';

class CartScreen extends StatelessWidget {
  final CartCubit _cubit = CartCubit();
  final VoidCallback shoppingCallback;

  CartScreen({
    required this.shoppingCallback,
  });

  void refresh() {
    _cubit.getCart();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => _cubit,
    child: CartView(
      shoppingCallback: shoppingCallback,
    ),
  );

}