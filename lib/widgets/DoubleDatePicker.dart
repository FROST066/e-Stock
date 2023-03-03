import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class DoubleDatePicker extends StatefulWidget {
  const DoubleDatePicker(
      {super.key,
      required this.dateDebutController,
      required this.dateFinController,
      required this.onChanged});
  final TextEditingController dateDebutController;
  final TextEditingController dateFinController;
  final void Function(String?) onChanged;

  @override
  State<DoubleDatePicker> createState() => _DoubleDatePickerState();
}

class _DoubleDatePickerState extends State<DoubleDatePicker> {
  @override
  void initState() {
    widget.dateDebutController.text = DateTime(2023).toString();
    widget.dateFinController.text = DateTime.now().toString();
    super.initState();
  }

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
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor.withAlpha(70)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.45 * 0.8,
                child: DateTimePicker(
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor),
                  controller: widget.dateDebutController,
                  dateMask: 'dd-MM-yyyy',
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  calendarTitle: "Selectionnez la date de début",
                  cancelText: "Annuler",
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black)),
                  onChanged: widget.onChanged,
                ),
              ),
              const Text("à"),
              Container(
                padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.45 * 0.8,
                child: DateTimePicker(
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor),
                  controller: widget.dateFinController,
                  dateMask: 'dd-MM-yyyy',
                  calendarTitle: "Selectionnez la date de fin",
                  cancelText: "Annuler",
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  decoration:
                      const InputDecoration(enabledBorder: InputBorder.none),
                  onChanged: widget.onChanged,
                  // onSaved: widget.onChanged,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
