import 'package:get/get.dart';
import 'hub_controller.dart';

class HubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HubController>(() => HubController());
  }
}
