import 'package:get/get.dart';
import 'add_fournisseur_controller.dart';

class AddFournisseurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFournisseurController>(() => AddFournisseurController());
  }
}
