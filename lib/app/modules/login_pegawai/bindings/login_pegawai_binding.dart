import 'package:get/get.dart';

import '../controllers/login_pegawai_controller.dart';

class LoginPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginPegawaiController>(
      () => LoginPegawaiController(),
    );
  }
}
