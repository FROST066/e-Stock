import 'package:flutter/material.dart';
import '../other/styles.dart';

class ReloadPlease extends StatelessWidget {
  const ReloadPlease({super.key, required this.futureFunc});
  final Function() futureFunc;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          child: Text(
              "Une erreur s'est produite. Verifiez votre connexion internet et rechargez la page"),
        ),
        ElevatedButton(
            style: defaultStyle(context),
            onPressed: () async => await futureFunc(),
            child: const Text("Recharger"))
      ],
    );
  }
}
