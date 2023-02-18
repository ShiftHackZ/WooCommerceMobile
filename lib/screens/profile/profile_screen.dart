import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/profile/profile_cubit.dart';
import 'package:wooapp/screens/profile/profile_view.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileCubit _cubit = ProfileCubit();

  ProfileScreen();

  void onTabOpened() {
    _cubit.onTabOpened();
  }
  
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => _cubit,
    child: ProfileView(),
  );
}
