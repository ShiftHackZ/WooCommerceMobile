import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/screens/viewed/viewed_products_state.dart';

class ViewedProductsCubit extends Cubit<ViewedProductsState> {
  final AppDb _db = locator<AppDb>();

  ViewedProductsCubit() : super(EmptyViewedProductsState());

  void getProducts() {
    _db.getViewedProducts().then((products) {
      print('[RECENT_VIEWED] products = $products');
      emit(ContentViewedProductsState(products));
    }).catchError((error) {
      print('[RECENT_VIEWED] error = $error');
      emit(EmptyViewedProductsState());
    });
  }
}
