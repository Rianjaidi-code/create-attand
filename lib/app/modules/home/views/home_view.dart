import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
          actions: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }
                String role = snapshot.data!.data()!["role"];
                if (role == "admin") {
                  return IconButton(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    icon: Icon(Icons.person),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;

              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),

                            //     child: Center(
                            //       child: Text("X"),
                            //     ),
                            //     // child: Image.network(src)
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WELCOME",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    user["address"] != null
                                        ? "${user['address']}"
                                        : "Belum ada lokasi",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user["nip"]}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${user["name"]}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.streamTodayAttand(),
                            builder: (context, snapToday) {
                              if (snapToday.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              Map<String, dynamic>? dataToday =
                                  snapToday.data?.data();
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text("Masuk"),
                                      Text(dataToday?["masuk"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                                    ],
                                  ),
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: [
                                      Text("Keluar"),
                                      Text(dataToday?["keluar"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                                    ],
                                  ),
                                ],
                              );
                            }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last 5 Days",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        // onPressed: () => Get.toNamed(
                        //   Routes.ALL_PRESENSI,
                        // ),
                        child: Text("See more"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastAttand(),
                      builder: (context, snapLastAttand) {
                        if (snapLastAttand.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapLastAttand.data?.docs.length == 0 ||
                            snapLastAttand.data == null) {
                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: Text("Belum ada history kehadiran."),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapLastAttand.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = snapLastAttand
                                .data!.docs.reversed
                                .toList()[index]
                                .data();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {},
                                  // onTap: () => Get.toNamed(
                                  //   Routes.DETAIL_PRESENSI,
                                  // ),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Masuk",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(data['masuk']?['date'] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Keluar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(data['keluar']?['date'] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ],
              );
            } else {
              return Center(
                child: Text("Tidak dapat memuat database user."),
              );
            }
          },
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
        )
        // floatingActionButton: Obx(
        //   () => FloatingActionButton(
        //     onPressed: () async {
        //       if (controller.isLoading.isFalse) {
        //         controller.isLoading.value = true;
        //         await FirebaseAuth.instance.signOut();
        //         controller.isLoading.value = false;
        //         Get.offAllNamed(Routes.LOGIN_PEGAWAI);
        //       }
        //     },
        //     child: controller.isLoading.isFalse
        //         ? Icon(Icons.logout)
        //         : CircularProgressIndicator(),
        //   ),
        // ),
        );
  }
}
