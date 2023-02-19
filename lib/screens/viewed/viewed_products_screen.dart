import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/database/entity/product.dart';
import 'package:wooapp/screens/viewed/viewed_products_cubit.dart';
import 'package:wooapp/screens/viewed/viewed_products_state.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_product_grid_slider.dart';
import 'package:wooapp/widget/widget_product_recent.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class ViewedProductsScreen extends StatelessWidget {
  final VoidCallback refreshCallback;

  ViewedProductsScreen(this.refreshCallback);

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ViewedProductsCubit(),
    child: ViewedProductsWidget(refreshCallback),
  );
}

class ViewedProductsWidget extends StatelessWidget {
  final VoidCallback refreshCallback;

  ViewedProductsWidget(this.refreshCallback);

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<ViewedProductsCubit>().getProducts();
      },
      child: Container(
        child: BlocListener<ViewedProductsCubit, ViewedProductsState>(
          listener: (context, state) {},
          child: BlocBuilder<ViewedProductsCubit, ViewedProductsState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case ContentViewedProductsState:
                  return _buildContent(context, (state as ContentViewedProductsState).viewedProducts);
                default:
                  return _buildEmpty();
              }
            },
          ),
        ),
      )
  );

  Widget _buildEmpty() => SizedBox.shrink();

  // Widget _buildContent(BuildContext context, List<ViewedProduct> products) => Container(
  //   height: 150,
  //   child: ListView.builder(
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       itemCount: products.length,
  //       physics: BouncingScrollPhysics(),
  //       itemBuilder: (context, index) => ProductGridSlidingWidget(viewedProduct: products[index])
  //   ),
  // );
  Widget _buildContent(BuildContext context, List<ViewedProduct> products) =>
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WooSectionHeading(tr('recently_viewed')),
            Container(
              height: 166,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: index == 0 || index == products.length - 1
                      ? EdgeInsets.only(
                          left: index == 0 ? 12 : 0,
                          right: index == products.length - 1 ? 12 : 0,
                        )
                      : EdgeInsets.zero,
                  child: ProductGridSlidingWidget(
                    viewedProduct: products[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
