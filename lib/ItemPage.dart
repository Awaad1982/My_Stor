import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';
import 'add_item_page.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() async {
    final data = await DatabaseHelper.instance.getAllItems();
    setState(() {
      _allItems = data;
      _filteredItems = data;
    });
  }

  void _filterItems(String query) {
    final filtered = _allItems.where((item) {
      final nameLower = item.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredItems = filtered;
    });
  }

  void _deleteItem(int id) async {
    // عرض رسالة تأكيد قبل الحذف
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا الصنف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // إذا وافق المستخدم على الحذف
    if (confirm == true) {
      await DatabaseHelper.instance.deleteItem(id); // استدعاء دالتك للحذف
      _refreshItems(); // تحديث القائمة بعد الحذف
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف الصنف بنجاح')),
      );
    }
  }

  void _openAddItem([Item? item]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddItemPage(item: item)),
    );
    if (result == true) _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأصناف')),
      body: Column(
        children: [
          // مربع البحث
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن صنف',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),

          // عرض الأصناف بالشبكة
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // معلومات الصنف
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text('سعر الشراء: ${item.buyPrice}'),
                            Text('سعر البيع: ${item.sellPrice}'),
                            Text('الكمية: ${item.quantity}'),
                          ],
                        ),
                        // أزرار تعديل وحذف
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openAddItem(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(item.id!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),

      // زر إضافة صنف جديد
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddItem(),
        child: Icon(Icons.add),
      ),
    );
  }
}