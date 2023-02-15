import 'package:flutter/material.dart';
import 'package:wooapp/model/attribute.dart';
import 'package:wooapp/model/product.dart';

class ProductVariationSelectionWidget extends StatefulWidget {
  final Product product;

  ProductVariationSelectionWidget({super.key, required this.product});

  @override
  State<StatefulWidget> createState() =>
      ProductVariationSelectionWidgetState();
}

class ProductVariationSelectionWidgetState
    extends State<ProductVariationSelectionWidget> {

  List<ProductAttribute> _variableAttrs = [];
  Map<String, String> _variations = {};

  @override
  void initState() {
    _genVariations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: _variableAttrs
          .map((attr) => _renderVariation(attr))
          .toList(),
    ),
  );

  Map<String, String> getVariations() => _variations;

  Widget _renderVariation(ProductAttribute attr) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        attr.name,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _variations['${attr.name}'],
          items: attr.options
              .map<DropdownMenuItem<String>>(
                (value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            // color: AppTheme.green_v2,
          ),
          onChanged: (value) {
            setState(() {
              _variations['${attr.name}'] = value.toString();
            });
          },
        )
      ),
    ],
  );

  void _genVariations() {
    for (var attr in widget.product.attributes) {
      if (attr.variation == null || attr.variation == false) continue;
      if (attr.visible == null || attr.visible == false) continue;
      _variableAttrs.add(attr);
    }
    for (var attr in _variableAttrs) {
      _variations.addAll({
        '${attr.name}': attr.options[0],
      });
    }
    setState(() {});
  }
}
