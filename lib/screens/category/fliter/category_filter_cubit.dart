import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/category_attribute_data_source.dart';
import 'package:wooapp/locator.dart';


import 'category_filter_state.dart';

class CategoryFilterCubit extends Cubit<CategoryFilterState> {
  final CategoryAttributeDateSource _ds = locator<CategoryAttributeDateSource>();
  final AppDb _db = locator<AppDb>();

  CategoryFilterCubit() : super(LoadingCategoryFilterState());

  void getAttributes() {
    _db.getFilters().then((filters) {
      emit(ContentCategoryFilterState(filters));
    }).catchError((error) {
      print('$error');
      emit(EmptyCategoryFilterState());
    });
    // emit(LoadingCategoryFilterState());
    // _ds.getAttributes().then((attrs) {
    //   if (attrs.isNotEmpty) {
    //     emit(ContentCategoryFilterState(attrs));
    //   } else {
    //     emit(EmptyCategoryFilterState());
    //   }
    // }).catchError((error) {
    //   emit(ErrorCategoryFilterState());
    // });
  }
}