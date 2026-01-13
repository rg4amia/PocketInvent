import 'package:get/get.dart';
import 'add_phone_controller.dart';

class AddPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPhoneController>(() => AddPhoneController());
  }
}
