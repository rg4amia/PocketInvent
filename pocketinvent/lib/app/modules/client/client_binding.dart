import 'package:get/get.dart';
import 'client_controller.dart';
import '../../data/services/client_service.dart';

class ClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientService>(() => ClientService());
    Get.lazyPut<ClientController>(() => ClientController());
  }
}
