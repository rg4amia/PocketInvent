import 'package:get/get.dart';
import 'fournisseur_controller.dart';
import '../../data/services/fournisseur_service.dart';

class FournisseurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FournisseurService>(() => FournisseurService());
    Get.lazyPut<FournisseurController>(() => FournisseurController());
  }
}
