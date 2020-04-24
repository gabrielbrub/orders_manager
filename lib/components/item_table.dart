import 'package:flutter/material.dart';

class ItemTable extends StatefulWidget {
  Function onIncrement;
  Function onDecrement;
  Function onDelete;
  Map itemMap;
  bool editable;

  ItemTable(
      {this.onDelete,
      this.onIncrement,
      this.onDecrement,
      this.itemMap,
      this.editable});

  @override
  _ItemTableState createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth()
      },
      children: createLines(),
    );
  }

  List<TableRow> createLines() {
    Color color;
    if (!widget.editable) {
      color = Colors.grey[600];
    }
    List<TableRow> rows = List();
    Map<String, int> _itemMap;
    rows.add(TableRow(
      children: [
        Center(child: Text('Product')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Amount')),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Actions')),
        ),
      ],
    ));
    widget.itemMap.forEach((product, amount) => rows.add(
          TableRow(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Text(product),
              ),
              Center(child: Text(amount.toString())),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: color),
                    onPressed: () {
                      if (widget.editable) widget.onDecrement(product, amount);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: color),
                    onPressed: () {
                      if (widget.editable) widget.onIncrement(product);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: color),
                    onPressed: () {
                      if (widget.editable) widget.onDelete(product);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));

    return rows;
  }
}


