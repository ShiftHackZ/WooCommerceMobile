import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/datasource/wish_list_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';

class WishListCubit extends Cubit<WishListState> {
  final WishListDataSource _ds = locator<WishListDataSource>();

  WishListCubit() : super(InitialWishListState()) {
    initialLoad();
  }

  void removeItem(int index) {
    if (state is! ContentWishListState) return;
    var entry = (state as ContentWishListState).wishlist[index];
    var newList = (state as ContentWishListState).wishlist..removeAt(index);
    emit(ContentWishListState(newList));
    _ds.removeProductByItemId(entry.first.itemId.toString());
  }

  void initialLoad() {
    emit(LoadingWishListState());
    _load();
  }

  void _load() {
    _ds.getWishListWithProducts().then((value) {
      emit(ContentWishListState(value));
    });
  }
}
