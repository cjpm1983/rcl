import 'package:get/get.dart';

import '../controllers/borrame_controller.dart';

class BorrameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BorrameController>(
      () => BorrameController(),
    );
  }
}
