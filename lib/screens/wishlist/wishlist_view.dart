import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/wishlist/wishlist_cubit.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/widget_product_grid.dart';

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
                case ContentWishListState:
                  return _contentState(context, state as ContentWishListState);
                default:
                  return _loadingState(context);
              }
            },
          ),
        ),
      );

  Widget _contentState(BuildContext context, ContentWishListState state) =>
      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: state.wishlist.length,
        itemBuilder: (ctx, i) => _buildProductItem(
          context,
          i,
          state.wishlist[i].second,
        ),
      );

  Widget _buildProductItem(
    BuildContext context,
    int index,
    Product product,
  ) =>
      Stack(
        alignment: Alignment.topRight,
        children: [
          ProductGridItem(
            product: product,
            detailRouteCallback: (result) {
              if (result == true) {
                context.read<WishListCubit>().initialLoad();
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
              right: 8,
            ),
            child: InkWell(
              onTap: () => context.read<WishListCubit>().removeItem(index),
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _loadingState(BuildContext context) => FeaturedShimmer(true);
}
