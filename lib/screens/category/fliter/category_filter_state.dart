import 'package:untitled/database/filter.dart';
import 'package:untitled/model/attribute.dart';

import 'category_filter_model.dart';

abstract class CategoryFilterState {}

class LoadingCategoryFilterState extends CategoryFilterState {}

class EmptyCategoryFilterState extends CategoryFilterState {}

class ContentCategoryFilterState extends CategoryFilterState {
  List<Filter> filters;

  ContentCategoryFilterState(this.filters);
}

class ErrorCategoryFilterState extends CategoryFilterState {}