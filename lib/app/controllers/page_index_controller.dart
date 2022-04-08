import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_presence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        print("Absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse[""] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].street} , ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          print(placemarks[0]);
          await updatePosition(position, address);

          //cek distance between 2 position
          double distance = Geolocator.distanceBetween(-6.29635420544798,
              106.84698150655245, position.latitude, position.longitude);

          //presensi
          await presensi(position, address, distance);
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE_PAGE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();

    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di dalam area";
    if (distance <= 50) {
      //didalam area
      if (snapPresence.docs.length == 0) {
        // belum pernah absen & set absen masuk
        await Get.defaultDialog(
          title: "Validasi",
          middleText:
              "Apakah kamu yakin akan mengisi daftar hadir ( MASUK ) sekarang ?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                await colPresence.doc(todayDocID).set(
                  {
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  },
                );
                Get.back();
                Get.snackbar("Berhasil", "Anda berhasil absen masuk.");
              },
              child: Text("YES"),
            ),
          ],
        );
      } else {
        // sudah pernah absen -> cek hari ini sudah absen masuk/belum
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await colPresence.doc(todayDocID).get();

        if (todayDoc.exists == true) {
          // tinggal absen keluar atau sudah absen masuk & keluar
          Map<String, dynamic>? dataPresence = todayDoc.data();
          if (dataPresence?["keluar"] != null) {
            //sudah absen masuk & keluar
            Get.snackbar("Informasi",
                "Kamu telah absen masuk dan keluar dan tidak dapat absen kembali.");
          } else {
            //absen keluar
            await Get.defaultDialog(
              title: "Validasi",
              middleText:
                  "Apakah kamu yakin akan mengisi daftar hadir ( Keluar ) sekarang ?",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).update(
                      {
                        "date": now.toIso8601String(),
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        }
                      },
                    );
                    Get.back();
                    Get.snackbar("Berhasil", "Anda berhasil absen keluar.");
                  },
                  child: Text("YES"),
                ),
              ],
            );
          }
        } else {
          //absen masuk
          await Get.defaultDialog(
            title: "Validasi",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir ( MASUK ) sekarang ?",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set(
                    {
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    },
                  );
                  Get.back();
                  Get.snackbar("Berhasil", "Anda berhasil absen masuk.");
                },
                child: Text("YES"),
              ),
            ],
          );
        }
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Maaf anda di luar jangkauan.");
    }

    // if (snapPresence.docs.length == 0) {
    //   // belum pernah absen & set absen masuk

    //   await colPresence.doc(todayDocID).set(
    //     {
    //       "date": now.toIso8601String(),
    //       "masuk": {
    //         "date": now.toIso8601String(),
    //         "lat": position.latitude,
    //         "long": position.longitude,
    //         "address": address,
    //         "status": status,
    //       }
    //     },
    //   );
    // } else {
    //   // sudah pernah absen -> cek hari ini sudah absen masuk/belum
    //   DocumentSnapshot<Map<String, dynamic>> todayDoc =
    //       await colPresence.doc(todayDocID).get();

    //   if (todayDoc.exists == true) {
    //     // tinggal absen keluar atau sudah absen masuk & keluar
    //     Map<String, dynamic>? dataPresence = todayDoc.data();
    //     if (dataPresence?["keluar"] != null) {
    //       //sudah absen masuk & keluar
    //       Get.snackbar("Sukses",
    //           "Kamu telah absen masuk dan keluar dan tidak dapat absen kembali.");
    //     } else {
    //       //absen keluar
    //       await colPresence.doc(todayDocID).update(
    //         {
    //           "keluar": {
    //             "date": now.toIso8601String(),
    //             "lat": position.latitude,
    //             "long": position.longitude,
    //             "address": address,
    //             "status": status,
    //           }
    //         },
    //       );
    //     }
    //   } else {
    //     //absen masuk
    //     Map<String, dynamic>? dataPresenceToday = todayDoc.data();

    //     await colPresence.doc(todayDocID).set(
    //       {
    //         "date": now.toIso8601String(),
    //         "masuk": {
    //           "date": now.toIso8601String(),
    //           "lat": position.latitude,
    //           "long": position.longitude,
    //           "address": address,
    //           "status": status,
    //         }
    //       },
    //     );
    //   }
    // }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengambil GPS dari device ini.",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin menggunakan GPS di tolak.",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Settingan kamu tidak diperbolehkan mengakses GPS. Mohon rubah Setting di hp anda.",
        "error": true,
      };

      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device.",
      "error": false,
    };
  }
}
