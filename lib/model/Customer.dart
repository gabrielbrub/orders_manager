class Customer{
  int id;
  String name;
  String cpf;
  String address;
  String phoneNumber;

  Customer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        cpf = json['cpf'],
        phoneNumber = json['phoneNumber'],
        address = json['address'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'cpf': cpf,
        'address' : address,
        'phoneNumber' : phoneNumber
      };

  Customer(this.name, this.cpf, this.address, this.phoneNumber);

}