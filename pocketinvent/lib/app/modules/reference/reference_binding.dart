import 'package:get/get.dart';
import 'reference_controller.dart';
import '../../data/services/reference_service.dart';

class ReferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferenceService>(() => ReferenceService());
    Get.lazyPut<ReferenceController>(() => ReferenceController());
  }
}
