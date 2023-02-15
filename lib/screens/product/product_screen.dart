import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/product/product_cubit.dart';
import 'package:wooapp/screens/product/product_view.dart';

class ProductScreen extends StatelessWidget {
  final int id;

  ProductScreen(this.id);

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProductCubit(id),
    child: ProductView(),
  );

}