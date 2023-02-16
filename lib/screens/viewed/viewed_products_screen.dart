import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/database/entity/product.dart';
import 'package:wooapp/screens/viewed/viewed_products_cubit.dart';
import 'package:wooapp/screens/viewed/viewed_products_state.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_product_recent.dart';

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
          listener: (context, state) {
            switch (state.runtimeType) {
              //ToDo ...
            }
          },
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

  Widget _buildContent(BuildContext context, List<ViewedProduct> products) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            'recently_viewed',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600
            ),
          ).tr(),
        ),
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.3),
              crossAxisCount: 3
              ,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) => RecentProductItem(products[index], refreshCallback)
        ),
      ],
    )
  );
}
