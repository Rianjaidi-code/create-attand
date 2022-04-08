import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password Page'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
              controller: controller.newPassC,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.newPassword();
              },
              child: Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
