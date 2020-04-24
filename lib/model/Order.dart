
class Order{
  int id;
  String customerCpf;
  String customerName;
  String status;
  String date;
  String creationDate;
  Map itemMap;

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        customerCpf = json['customer']['cpf'],
        customerName = json['customer']['name'],
        date = json['date'],
        itemMap = json['products'],
        status = json['status'],
        creationDate = json['creationDate'];


  Map<String, dynamic> toJson() =>
      {
        'date': date,
        'customerCpf' : customerCpf,
        'products' : itemMap,
        'status' : status
      };


  Order(this.customerCpf, this.date, this.itemMap);
}