import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BasicDateTimeField extends StatelessWidget {
  final formatter = DateFormat("yyyy-MM-dd HH:mm");
  DateTime currentValue;
  TextEditingController _dateController = TextEditingController();
  String datePicked;

  BasicDateTimeField.withDate(this.currentValue):assert(currentValue != null);
  BasicDateTimeField();




  @override
  Widget build(BuildContext context) {
    if(currentValue != null)
      _dateController.text = formatter.format(currentValue);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DateTimeField(
        enabled: true,
        controller: _dateController,
        decoration: InputDecoration(
          labelText: 'Order date',
        ),
        style: TextStyle(
          fontSize: 24.0,
        ),
        format: formatter,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            datePicked = formatter.format(DateTimeField.combine(date, time));
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }
}