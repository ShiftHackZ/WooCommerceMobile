import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/profile/profile_cubit.dart';
import 'package:wooapp/screens/profile/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileCubit _cubit = ProfileCubit();
  final VoidCallback shoppingCallback;
  final VoidCallback settingsChangedCallback;

  ProfileScreen({
    required this.shoppingCallback,
    required this.settingsChangedCallback,
  });

  void onTabOpened() => _cubit.onTabOpened();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => _cubit,
        child: ProfileView(
          shoppingCallback: shoppingCallback,
          settingsChangedCallback: settingsChangedCallback,
        ),
      );
}
