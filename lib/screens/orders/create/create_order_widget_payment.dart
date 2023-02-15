import 'package:flutter/material.dart';
import 'package:wooapp/model/payment_method.dart';

class CreateOrderPaymentWidget extends StatelessWidget {
  final int selectionIndex;
  final List<PaymentMethod> methods;
  final ValueSetter<int> onSelected;

  CreateOrderPaymentWidget(this.selectionIndex, this.methods, this.onSelected);

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    child: ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: methods.length,
      itemBuilder: (context, index) => _methodItem(methods[index], index == selectionIndex, index),
    ),
  );

  Widget _methodItem(PaymentMethod method, bool isSelected, int index) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11.0),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => onSelected(index),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.deepPurple),
                  value: isSelected,
                  shape: CircleBorder(),
                  onChanged: (value) => onSelected(index)
              ),
              Text('${method.title}', style: TextStyle(fontSize: 15.8))
            ],
          ),
          // Text('${method.description}')
        ],
      ),
    ),
  );
}