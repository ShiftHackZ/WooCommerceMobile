import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/core/pop_controller.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/screens/wishlist/wishlist_cubit.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/widget_empty_state.dart';
import 'package:wooapp/widget/widget_error_state.dart';
import 'package:wooapp/widget/widget_product_feed.dart';
import 'package:wooapp/widget/widget_product_grid.dart';

class WishListView extends StatelessWidget {
  final _willPopController = WillPopController(
    value: WishListExitPayload(false, false),
  );

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: BlocListener<WishListCubit, WishListState>(
          listener: (context, state) {},
          child: BlocBuilder<WishListCubit, WishListState>(
            builder: (context, state) {
              bool? displayGrid;
              Widget stateWidget;
              switch (state.runtimeType) {
                case ContentWishListState:
                  displayGrid = (state as ContentWishListState).displayGrid;
                  stateWidget = _contentState(context, state);
                  break;
                case EmptyWishListState:
                  stateWidget = _emptyState(context);
                  break;
                case ErrorWishListState:
                  stateWidget = _errorState(context);
                  break;
                case LoadingWishListState:
                  stateWidget = _loadingState(
                    context,
                    (state as LoadingWishListState).displayGrid,
                  );
                  break;
                default:
                  stateWidget = Container(); //_loadingState(context);
              }
              return _screenWrapper(
                context,
                stateWidget,
                displayGrid: displayGrid,
              );
            },
          ),
        ),
        onWillPop: () {
          Navigator.pop(context, _willPopController.value);
          return Future(() => false);
        },
      );

  Widget _screenWrapper(
    BuildContext context,
    Widget widget, {
    bool? displayGrid,
  }) =>
      Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'wish_list',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          backgroundColor: WooAppTheme.colorToolbarBackground,
          actions: [
            if (displayGrid != null)
              IconButton(
                onPressed: () {
                  var exit = (_willPopController.value as WishListExitPayload);
                  _willPopController.value = WishListExitPayload(true, exit.routeMainPage);
                  context.read<WishListCubit>().toggleDisplayMode();
                },
                icon: Icon(
                  displayGrid
                      ? Icons.grid_view_rounded
                      : Icons.view_agenda_rounded,
                  color: WooAppTheme.colorToolbarForeground,
                ),
              ),
          ],
        ),
        body: widget,
      );

  Widget _errorState(BuildContext context) => WooErrorStateWidget(() {
        context.read<WishListCubit>().initialLoad();
      });

  Widget _emptyState(BuildContext context) => WooEmptyStateWidget(
        mainAxisAlignment: MainAxisAlignment.center,
        animation: WooEmptyStateAnimation.wishlist,
        keySubTitle: 'wish_list_empty_subtitle',
        action: WooEmptyStateAction(
          buttonLabel: tr('cart_empty_action'),
          buttonClick: () {
            var exit = (_willPopController.value as WishListExitPayload);
            _willPopController.value = WishListExitPayload(exit.changedDisplayMode, true);
            Navigator.pop(context, _willPopController.value);
          },
          icon: FontAwesomeIcons.basketShopping,
        ),
      );

  Widget _contentState(BuildContext context, ContentWishListState state) {
    if (state.displayGrid)
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: state.wishlist.length,
        itemBuilder: (ctx, i) => _buildGridProductItem(
          context,
          i,
          state.wishlist[i].second,
        ),
      );
    return ListView.builder(
      itemCount: state.wishlist.length,
      itemBuilder: (ctx, i) => _buildFeedProductItem(
        context,
        i,
        state.wishlist[i].second,
      ),
    );
  }

  Widget _buildFeedProductItem(
    BuildContext context,
    int index,
    Product product,
  ) =>
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          ProductFeedWidget(
            product: product,
            onProductAction: () {},
            onImageClicked: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductScreen(product.id),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 8,
              right: 107,
            ),
            child: InkWell(
              onTap: () => context.read<WishListCubit>().removeItem(index),
              child: CircleAvatar(
                backgroundColor: WooAppTheme.colorDangerActionBackground,
                radius: 19,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Icon(
                    Icons.delete_outline,
                    color: WooAppTheme.colorDangerActionForeground,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildGridProductItem(
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
                backgroundColor: WooAppTheme.colorDangerActionBackground,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Icon(
                    Icons.delete_outline,
                    color: WooAppTheme.colorDangerActionForeground,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _loadingState(BuildContext context, bool displayGrid) {
    if (displayGrid) return FeaturedShimmer(true);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductFeedItemShimmer(),
          ProductFeedItemShimmer(),
        ],
      ),
    );
  }
}
