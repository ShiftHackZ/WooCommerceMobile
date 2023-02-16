import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/model/cart_response.dart';
import 'package:wooapp/screens/auth/no_auth_screen.dart';
import 'package:wooapp/screens/cart/cart_cubit.dart';
import 'package:wooapp/screens/cart/cart_state.dart';
import 'package:wooapp/screens/orders/create/create_order_screen.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/screens/viewed/viewed_products_screen.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_cart_empty.dart';
import 'package:wooapp/widget/widget_cart_total.dart';
import 'package:wooapp/widget/widget_retry.dart';

class CartView extends StatelessWidget {
  final VoidCallback shoppingCallback;
  final VoidCallback authCompleteCallback;

  CartView({
    required this.shoppingCallback,
    required this.authCompleteCallback,
  });

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () => context.read<CartCubit>().getCart(),
      child: Scaffold(
        backgroundColor: WooAppTheme.colorCommonBackground,
        appBar: _appBar(),
        body: SafeArea(
          child: BlocListener<CartCubit, CartState>(
            listener: (context, state) {},
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case InitialCartState:
                    return _loadingState();
                  case LoadingCartState:
                    return _loadingState();
                  case EmptyCartState:
                    return _emptyState(context);
                  case ContentCartState:
                    return _contentState(context, (state as ContentCartState).cart);
                  case ErrorCartState:
                    return _errorState(context);
                  case NoAuthCartState:
                    return _noAuth(context);
                  default:
                    return _loadingState();
                }
              },
            ),
          ),
        ),
      ),
  );

  Widget _noAuth(BuildContext context) => NoAuthScreen(tr('tab_cart'), () {
    authCompleteCallback();
    Future.delayed(Duration(milliseconds: 200), () {
      context.read<CartCubit>().getCart();
    });
  });

  Widget _emptyState(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            EmptyCartWidget(shoppingCallback),
            SizedBox(height: 50),
            ViewedProductsScreen(() => context.read<CartCubit>().getCart()),
          ],
        ),
  );

  Widget _contentState(BuildContext context, CartResponse cart) => Scaffold(
    backgroundColor: WooAppTheme.colorCommonBackground,
    bottomNavigationBar: Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(right: 36, left: 36, bottom: 16),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CreateOrderScreen())
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.check),
                SizedBox(width: 8),
                Text(
                  'cart_checkout_full',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ).tr(),
              ],
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF62A1E2)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                  side: BorderSide(color: Colors.blue)
              ),
            ),
          ),
        ),
      ),
    ),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() {
          context.read<CartCubit>().getCart();
        }),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in cart.items) _buildCartItem(context, item),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildCartItem(BuildContext context, CartItem item) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: _buildItemImage(context, item.id, item.featuredImage),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 6),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) => ProductScreen(item.id )));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                child: Text(
                                  '${item.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                context.read<CartCubit>().deleteItem(item.itemKey, item.id);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: 16,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  child: Icon(Icons.delete_outline, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 6),
                        child: CartTotalItem(item),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildItemImage(BuildContext context, int id, String image) => Container(
    width: 100,
    height: 100,
    child: InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProductScreen(id)));
      },
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer(
            duration: Duration(seconds: 1),
            enabled: true,
            direction: ShimmerDirection.fromLTRB(),
            child: Container(color: Colors.white10)
        ),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      ),
    ),
  );

  Widget _loadingState() => CartListShimmer();

  Widget _errorState(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            ErrorRetryWidget(() => context.read<CartCubit>().getCart()),
          ]
        ),
  );

  AppBar _appBar() => AppBar(
    leading: Icon(Icons.shopping_cart),
    title: Text('tab_cart').tr(),
    backgroundColor: WooAppTheme.colorCommonToolbar,
  );
}