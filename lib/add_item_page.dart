import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';

class AddItemPage extends StatefulWidget {
  final Item? item;

  AddItemPage({this.item});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _buyController = TextEditingController();
  final TextEditingController _sellController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _buyController.text = widget.item!.buyPrice.toString();
      _sellController.text = widget.item!.sellPrice.toString();
      _quantityController.text = widget.item!.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'إضافة صنف' : 'تعديل صنف'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // اسم الصنف
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم الصنف',
                      prefixIcon: Icon(Icons.inventory_2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال اسم الصنف' : null,
                  ),
                  SizedBox(height: 16),

                  // سعر الشراء
                  TextFormField(
                    controller: _buyController,
                    decoration: InputDecoration(
                      labelText: 'سعر الشراء',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال سعر الشراء' : null,
                  ),
                  SizedBox(height: 16),

                  // سعر البيع
                  TextFormField(
                    controller: _sellController,
                    decoration: InputDecoration(
                      labelText: 'سعر البيع',
                      prefixIcon: Icon(Icons.money_off),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال سعر البيع' : null,
                  ),
                  SizedBox(height: 16),

                  // الكمية
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'الكمية',
                      prefixIcon: Icon(Icons.production_quantity_limits),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال الكمية' : null,
                  ),
                  SizedBox(height: 25),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newItem = Item(
                            name: _nameController.text,
                            buyPrice: double.parse(_buyController.text),
                            sellPrice: double.parse(_sellController.text),
                            quantity: int.parse(_quantityController.text),
                          );

                          if (widget.item == null) {
                            await DatabaseHelper.instance.insertItem(newItem);
                          } else {
                            newItem.id = widget.item!.id;
                            await DatabaseHelper.instance.updateItem(newItem);
                          }

                          Navigator.pop(context, true); // العودة مع تحديث الجدول
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text(
                        'حفظ',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}