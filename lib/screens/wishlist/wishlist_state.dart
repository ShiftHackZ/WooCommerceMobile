import 'package:wooapp/core/pair.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/model/wish_list_entry.dart';

abstract class WishListState {}

class InitialWishListState extends WishListState {}

class LoadingWishListState extends WishListState {}

class EmptyWishListState extends WishListState {}

class ContentWishListState extends WishListState {
  List<Pair<WishListEntry, Product>> wishlist;

  ContentWishListState(this.wishlist);
}

class ErrorWishListState extends WishListState {

}
