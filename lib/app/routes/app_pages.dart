import 'package:get/get.dart';

import 'package:flutter_presence/app/modules/all_presensi/bindings/all_presensi_binding.dart';
import 'package:flutter_presence/app/modules/all_presensi/views/all_presensi_view.dart';
import 'package:flutter_presence/app/modules/detail_presensi/bindings/detail_presensi_binding.dart';
import 'package:flutter_presence/app/modules/detail_presensi/views/detail_presensi_view.dart';
import 'package:flutter_presence/app/modules/home/bindings/home_binding.dart';
import 'package:flutter_presence/app/modules/home/views/home_view.dart';
import 'package:flutter_presence/app/modules/login_pegawai/bindings/login_pegawai_binding.dart';
import 'package:flutter_presence/app/modules/login_pegawai/views/login_pegawai_view.dart';
import 'package:flutter_presence/app/modules/new_password/bindings/new_password_binding.dart';
import 'package:flutter_presence/app/modules/new_password/views/new_password_view.dart';
import 'package:flutter_presence/app/modules/profile_page/bindings/profile_page_binding.dart';
import 'package:flutter_presence/app/modules/profile_page/views/profile_page_view.dart';
import 'package:flutter_presence/app/modules/register/bindings/register_binding.dart';
import 'package:flutter_presence/app/modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LOGIN_PEGAWAI,
      page: () => LoginPegawaiView(),
      binding: LoginPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_PAGE,
      page: () => ProfilePageView(),
      binding: ProfilePageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
  ];
}
