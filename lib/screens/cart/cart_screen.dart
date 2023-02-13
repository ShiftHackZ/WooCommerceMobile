import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/screens/cart/cart_cubit.dart';
import 'package:untitled/screens/cart/cart_view.dart';

class CartScreen extends StatelessWidget {
  final CartCubit cubit = CartCubit();
  final VoidCallback shoppingCallback;

  CartScreen(this.shoppingCallback);

  void refresh() {
    cubit.getCart();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => cubit,
    child: CartView(shoppingCallback),
  );

}