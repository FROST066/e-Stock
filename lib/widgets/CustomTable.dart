import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle ts = GoogleFonts.abel(
    fontSize: 13, decoration: TextDecoration.none, color: Colors.black);
Widget customTableWithMap(Map<String, String> map, BuildContext ctx) {
  print("Map selected:");
  print(map);
  List<String> keys = map.keys.toList();
// map.en
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Table(
      border: TableBorder.all(color: Theme.of(ctx).textTheme.bodyText2!.color!),
      children: keys
          .map((e) => TableRow(children: [
                TableCell(child: centerText(e, ctx)),
                TableCell(child: centerText(map[e]!, ctx)),
              ]))
          .toList(),
    ),
  );
}

Widget customTableWithArray(List<List<String>> tab, BuildContext ctx) {
  print(tab);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Table(
      border: TableBorder.all(
          width: 2, color: Theme.of(ctx).textTheme.bodyText2!.color!),
      children: tab
          .map((e) => TableRow(
              children: e
                  .map(
                    (e) => TableCell(child: centerText(e, ctx)),
                  )
                  .toList()))
          .toList(),
    ),
  );
}

Widget centerText(String text, ctx) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.abel(
            fontSize: 13,
            decoration: TextDecoration.none,
            color: Theme.of(ctx).textTheme.bodyText2!.color!),
      ),
    ),
  );
}
