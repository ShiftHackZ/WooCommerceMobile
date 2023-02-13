import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/screens/profile/profile_cubit.dart';
import 'package:untitled/screens/profile/profile_view.dart';

class ProfileScreen extends StatelessWidget {

  ProfileScreen();

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileCubit(),
    child: ProfileView(),
  );
}
