class Product {
  int id;
  String name;
  double price;

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'price' : price
      };

  Product(this.name, this.price);
}