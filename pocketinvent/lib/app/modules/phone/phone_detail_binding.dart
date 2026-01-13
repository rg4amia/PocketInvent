import 'package:get/get.dart';
import 'phone_detail_controller.dart';

class PhoneDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneDetailController>(() => PhoneDetailController());
  }
}
