import 'package:wooapp/model/attribute.dart';

class CategoryFilterModel {
  Attribute attribute;
  List<Term> terms;

  CategoryFilterModel(this.attribute, this.terms);
}