import 'package:flutter/material.dart';

class YearDropdown extends StatefulWidget {
  const YearDropdown({Key? key, required this.CurrentYear}) : super(key: key);
  final Function(int value) CurrentYear;
  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  final List<int> years = List<int>.generate(
    30, // عدد السنوات (مثال: آخر 30 سنة)
    (index) => DateTime.now().year - index,
  );

  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'select year',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedYear,
      items: years.map((year) {
        return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
          widget.CurrentYear(value!);
        });
      },
      validator: (value) => value == null ? 'enter year ,please' : null,
    );
  }
}
