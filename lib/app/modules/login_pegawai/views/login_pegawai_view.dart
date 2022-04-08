import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_pegawai_controller.dart';

class LoginPegawaiView extends GetView<LoginPegawaiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Silahkan lakukan Login\nterlebih dahulu',
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
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: controller.emailC,
            ),
            SizedBox(height: 10),
            TextField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              controller: controller.passwordC,
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.login();
                  }
                },
                child:
                    Text(controller.isLoading.isFalse ? "Login" : "LOADING..."),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Lupa Password'),
            ),
          ],
        ),
      ),
    );
  }
}
