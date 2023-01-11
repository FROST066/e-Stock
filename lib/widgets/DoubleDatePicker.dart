import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../other/styles.dart';

class DoubleDatePicker extends StatefulWidget {
  const DoubleDatePicker({super.key});

  @override
  State<DoubleDatePicker> createState() => _DoubleDatePickerState();
}

class _DoubleDatePickerState extends State<DoubleDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            "Selectionner la période",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          margin: const EdgeInsets.only(bottom: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: appGrey),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.45 * 0.8,
                child: DateTimePicker(
                  initialValue: DateTime.now().toString(),
                  dateMask: 'd-MM-yyyy',
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  calendarTitle: "Selectionnez la date de début",
                  cancelText: "Annuler",
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (val) => print(val),
                  onSaved: (val) => print(val),
                ),
              ),
              const Text("à"),
              Container(
                padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.45 * 0.8,
                child: DateTimePicker(
                  initialValue: DateTime.now().toString(),
                  dateMask: 'd-MM-yyyy',
                  calendarTitle: "Selectionnez la date de fin",
                  cancelText: "Annuler",
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (val) => print(val),
                  onSaved: (val) => print(val),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
