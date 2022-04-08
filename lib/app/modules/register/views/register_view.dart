import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Silahkan lakukan Register\nterlebih dahulu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
              controller: controller.nipC,
            ),
            SizedBox(height: 10),
            TextField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              controller: controller.nameC,
            ),
            SizedBox(height: 10),
            TextField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: controller.emailC,
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.register();
                  }
                },
                child: Text(controller.isLoading.isFalse
                    ? "DAFTAR PEGAWAI"
                    : "LOADING"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
