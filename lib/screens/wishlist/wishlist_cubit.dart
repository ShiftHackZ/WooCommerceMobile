import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/datasource/wish_list_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/preferences/preferences_manager.dart';
import 'package:wooapp/screens/wishlist/wishlist_state.dart';

class WishListCubit extends Cubit<WishListState> {
  final PreferencesManager _preferences = locator<PreferencesManager>();
  final WishListDataSource _ds = locator<WishListDataSource>();

  bool _displayGrid = true;

  WishListCubit() : super(InitialWishListState()) {
    initialLoad();
  }

  void toggleDisplayMode() {
    if (state is! ContentWishListState) return;
    _preferences.setGridDisplayEnabled(!_displayGrid);
    _displayGrid = !_displayGrid;
    emit(
      ContentWishListState(
        displayGrid: _displayGrid,
        wishlist: (state as ContentWishListState).wishlist,
      ),
    );
  }

  void removeItem(int index) {
    if (state is! ContentWishListState) return;
    var entry = (state as ContentWishListState).wishlist[index];
    var newList = (state as ContentWishListState).wishlist..removeAt(index);
    if (newList.isEmpty) emit(EmptyWishListState());
    else emit(ContentWishListState(displayGrid: _displayGrid, wishlist: newList));
    _ds.removeProductByItemId(entry.first.itemId.toString());
  }

  void initialLoad() async {
    await _preferences
        .getGridDisplayEnabled()
        .then((value) => _displayGrid = value);

    emit(LoadingWishListState(displayGrid: _displayGrid));
    _load();
  }

  void _load() {
    _ds.getWishListWithProducts().then((value) {
      if (value.isEmpty) emit(EmptyWishListState());
      else emit(ContentWishListState(displayGrid: _displayGrid, wishlist: value));
    }).catchError((error, stackTrace) {
      Completer().completeError(error, stackTrace);
      emit(ErrorWishListState());
    });
  }
}
