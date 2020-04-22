
class Order{
  int id;
  String customerCpf;
  String customerName;
  String status;
  String date;
  String creationDate;
  List itemList;
  //Map itemMap;

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        customerCpf = json['customer']['cpf'],
        customerName = json['customer']['name'],
        date = json['date'],
        status = json['status'],
        creationDate = json['creationDate'],
        itemList = json['items'];

  Map<String, dynamic> toJson() =>
      {
        'date': date,
        'customerCpf' : customerCpf,
        'products' : _toMap(itemList),
        'status' : status
      };

  Map<String, int> _toMap(List itemList){
    Map<String, int> itemMap = Map();
    for(Map<String, dynamic> map in itemList){
      print(map['product']['name']);
      print(map['amount']);
      itemMap.putIfAbsent(map['product']['name'], () => map['amount']);
    }
    return itemMap;
  }

  //Order(this.customerCpf, this.customerName, this.date, this.creationDate, this.itemMap);
}