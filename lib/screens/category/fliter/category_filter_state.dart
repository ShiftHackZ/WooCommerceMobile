import 'package:wooapp/database/filter.dart';
import 'package:wooapp/model/attribute.dart';

import 'category_filter_model.dart';

abstract class CategoryFilterState {}

class LoadingCategoryFilterState extends CategoryFilterState {}

class EmptyCategoryFilterState extends CategoryFilterState {}

class ContentCategoryFilterState extends CategoryFilterState {
  List<Filter> filters;

  ContentCategoryFilterState(this.filters);
}

class ErrorCategoryFilterState extends CategoryFilterState {}