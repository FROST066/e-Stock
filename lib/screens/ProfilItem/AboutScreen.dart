import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("A propos")),
      body: Center(
        heightFactor: 1,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "A propos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    '''E-Stock est une entreprise spécialisée dans la gestion de stock
pour les entreprises de toutes tailles. Nous offrons des solutions de
gestion de stock innovantes et personnalisées pour répondre aux
besoins uniques de chaque client.\n\nNous sommes ﬁers de proposer des solutions de gestion de stock
innovantes et à la pointe de la technologie. Nos solutions de
gestion de stock en ligne permettent aux entreprises d'accéder en
temps réel à leur stock, de suivre leur inventaire et d'analyser leurs
données pour améliorer leur prise de décision.\n\nChez e-Stock, nous sommes engagés à fournir à nos clients un
service de qualité supérieure et une expérience client
exceptionnelle. Nous sommes impatients de travailler avec vous
pour améliorer votre gestion de stock et vous aider à atteindre vos
objectifs commerciaux.''',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
