class Item {
  int? id;
  String name;
  double buyPrice;
  double sellPrice;
  int quantity;

  Item({
    this.id,
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      buyPrice: map['buyPrice'],
      sellPrice: map['sellPrice'],
      quantity: map['quantity'],
    );
  }
}