import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/datasource/wish_list_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';

class WishListCubit extends Cubit<WishListState> {
  final WishListDataSource _ds = locator<WishListDataSource>();

  WishListCubit() : super(InitialWishListState()) {
    _load();
  }

  void _load() {
    emit(LoadingWishListState());
    _ds.getWishListWithProducts().then((value) {
      print('DBG0: $value');
    });
  }
}
