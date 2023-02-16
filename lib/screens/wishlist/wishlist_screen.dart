import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/wishlist/wishlist_cubit.dart';
import 'package:wooapp/screens/wishlist/wishlist_view.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => WishListCubit(),
        child: WishListView(),
      );
}
