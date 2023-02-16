import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/product_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/product/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final int _productId;
  
  final ProductDataSource _dsProduct = locator<ProductDataSource>();
  final AppDb _db = locator<AppDb>();
  
  ProductCubit(this._productId) : super(InitialProductState()) {
    _getProduct();
  }

  void _getProduct() {
    emit(LoadingProductState());
    _dsProduct.getProduct(_productId).then((product) {
      _db.saveProductView(product);
      emit(ContentProductState(product));
    }).catchError((error, stacktrace) {
      Completer().completeError(error, stacktrace);
      emit(ErrorProductState());
    });
  }
}
