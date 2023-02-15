import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/screens/wishlist/wishlist_cubit.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';

class WishListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('wish_list').tr(),
        ),
        backgroundColor: Colors.white,
        body: BlocListener<WishListCubit, WishListState>(
          listener: (context, state) {},
          child: BlocBuilder<WishListCubit, WishListState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                // case InitialProfileState:
                //   return _loadingState(context);
                // case LoadingProfileState:
                //   return _loadingState(context);
                // case ContentProfileState:
                //   return _contentState(context, (state as ContentProfileState).profile);
                // case ErrorProfileState:
                //   return _errorState();
                // case NoAuthProfileState:
                //   return _noAuth(context);
                default:
                  return _loadingState(context);
              }
            },
          ),
        ),
      );

  Widget _loadingState(BuildContext context) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      );
}
