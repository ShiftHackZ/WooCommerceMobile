import 'package:wooapp/core/pair.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/model/wish_list_entry.dart';

abstract class WishListState {}

class InitialWishListState extends WishListState {}

class LoadingWishListState extends WishListState {
  bool displayGrid;

  LoadingWishListState({this.displayGrid = true});
}

class EmptyWishListState extends WishListState {}

class ContentWishListState extends WishListState {
  bool displayGrid;
  List<Pair<WishListEntry, Product>> wishlist;

  ContentWishListState({
    required this.displayGrid,
    required this.wishlist,
  });
}

class ErrorWishListState extends WishListState {

}
