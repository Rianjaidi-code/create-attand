import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence/app/controllers/page_index_controller.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    daftarMenu() {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading.value = true;
                await FirebaseAuth.instance.signOut();
                controller.isLoading.value = false;
                Get.offAllNamed(Routes.LOGIN_PEGAWAI);
              }
            },
            child: Text("LOGOUT"),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            daftarMenu(),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value, //optional, default as 0
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
