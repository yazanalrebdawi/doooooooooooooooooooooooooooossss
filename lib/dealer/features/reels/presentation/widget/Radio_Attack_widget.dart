import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';

class RadioAttackWidget extends StatefulWidget {
  @override
  _RadioAttackWidgetState createState() => _RadioAttackWidgetState();
}

enum Category { none, product, service }

class _RadioAttackWidgetState extends State<RadioAttackWidget> {
  Category _selected = Category.none; // القيمة الافتراضية

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        // إطار أزرق مثل الصورة
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<Category>(
            activeColor: Colors.blue,

            title: Text('None', style: AppTextStyle.poppins414BD),
            value: Category.none,
            groupValue: _selected,
            onChanged: (value) {
              setState(() => _selected = value!);
            },
          ),
          RadioListTile<Category>(
            title: Text('Product', style: AppTextStyle.poppins414BD),
            value: Category.product,
            groupValue: _selected,
            onChanged: (value) {
              setState(() => _selected = value!);
            },
          ),
          RadioListTile<Category>(
            title: Text('Service', style: AppTextStyle.poppins414BD),
            value: Category.service,
            groupValue: _selected,
            onChanged: (value) {
              setState(() => _selected = value!);
            },
          ),
        ],
      ),
    );
  }
}
