import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle ts = GoogleFonts.abel(
    fontSize: 13, decoration: TextDecoration.none, color: Colors.black);
Widget customTable(Map<String, String> map) {
  print("Map selected:");
  print(map);
  List<String> keys = map.keys.toList();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Table(
      border: TableBorder.all(),
      children: keys
          .map((e) => TableRow(children: [
                TableCell(child: centerText(e)),
                TableCell(child: centerText(map[e]!)),
              ]))
          .toList(),
    ),
  );
}

Widget centerText(String text) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Text(
        text,
        style: ts,
      ),
    ),
  );
}
