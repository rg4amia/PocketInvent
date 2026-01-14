import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reference_controller.dart';
import 'widgets/marque_tab.dart';
import 'widgets/modele_tab.dart';
import 'widgets/couleur_tab.dart';
import 'widgets/capacite_tab.dart';
import 'widgets/statut_tab.dart';

class ReferenceView extends GetView<ReferenceController> {
  const ReferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Données de référence'),
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Marques'),
            Tab(text: 'Modèles'),
            Tab(text: 'Couleurs'),
            Tab(text: 'Capacités'),
            Tab(text: 'Statuts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          MarqueTab(),
          ModeleTab(),
          CouleurTab(),
          CapaciteTab(),
          StatutTab(),
        ],
      ),
    );
  }
}
