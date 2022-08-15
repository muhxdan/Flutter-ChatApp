import 'package:get/get.dart';

import 'package:chatapp/app/modules/addProfile/bindings/add_profile_binding.dart';
import 'package:chatapp/app/modules/addProfile/views/add_profile_view.dart';
import 'package:chatapp/app/modules/chat/bindings/chat_binding.dart';
import 'package:chatapp/app/modules/chat/views/chat_view.dart';
import 'package:chatapp/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:chatapp/app/modules/dashboard/views/dashboard_view.dart';
import 'package:chatapp/app/modules/profile/bindings/profile_binding.dart';
import 'package:chatapp/app/modules/profile/views/profile_view.dart';
import 'package:chatapp/app/modules/search/bindings/search_binding.dart';
import 'package:chatapp/app/modules/search/views/search_view.dart';
import 'package:chatapp/app/modules/signin/bindings/signin_binding.dart';
import 'package:chatapp/app/modules/signin/views/signin_view.dart';
import 'package:chatapp/app/modules/splash/bindings/splash_binding.dart';
import 'package:chatapp/app/modules/splash/views/splash_view.dart';
import 'package:chatapp/app/modules/verify/bindings/verify_binding.dart';
import 'package:chatapp/app/modules/verify/views/verify_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY,
      page: () => VerifyView(),
      binding: VerifyBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PROFILE,
      page: () => AddProfileView(),
      binding: AddProfileBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
