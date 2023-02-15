import 'package:wooapp/model/product.dart';

abstract class ProductState {}

class InitialProductState extends ProductState {}

class LoadingProductState extends ProductState {}

class ContentProductState extends ProductState {
  final Product product;

  ContentProductState(this.product);
}

class ErrorProductState extends ProductState {}
