import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/screens/profile/edit/profile_edit_view.dart';
import 'package:untitled/screens/profile/profile_cubit.dart';

class ProfileEditScreen extends StatelessWidget {

  ProfileEditScreen();

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileCubit(),
    child: ProfileEditView(),
  );

}