import 'package:wooapp/database/product.dart';

abstract class ViewedProductsState {}

class EmptyViewedProductsState extends ViewedProductsState {}

class ContentViewedProductsState extends ViewedProductsState {
  final List<ViewedProduct> viewedProducts;

  ContentViewedProductsState(this.viewedProducts);
}
