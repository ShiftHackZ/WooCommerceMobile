import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/orders/create/create_order_cubit.dart';
import 'package:wooapp/screens/orders/create/create_order_view.dart';

class CreateOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CreateOrderCubit(),
    child: CreateOrderView(),
  );
}