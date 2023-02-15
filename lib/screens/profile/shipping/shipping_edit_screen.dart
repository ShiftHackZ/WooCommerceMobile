import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/profile/profile_cubit.dart';
import 'package:wooapp/screens/profile/shipping/shipping_edit_view.dart';

class ShippingEditScreen extends StatelessWidget {

  ShippingEditScreen();

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileCubit(),
    child: ShippingEditView(),
  );
}
