import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/hub/hub_binding.dart';
import '../modules/hub/hub_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/phone/add_phone_binding.dart';
import '../modules/phone/add_phone_view.dart';
import '../modules/phone/phone_detail_binding.dart';
import '../modules/phone/phone_detail_view.dart';
import '../modules/fournisseur/fournisseur_binding.dart';
import '../modules/fournisseur/fournisseur_view.dart';
import '../modules/client/client_binding.dart';
import '../modules/client/client_view.dart';
import '../modules/reference/reference_binding.dart';
import '../modules/reference/reference_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HUB,
      page: () => const HubView(),
      binding: HubBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PHONE,
      page: () => const AddPhoneView(),
      binding: AddPhoneBinding(),
    ),
    GetPage(
      name: _Paths.PHONE_DETAIL,
      page: () => const PhoneDetailView(),
      binding: PhoneDetailBinding(),
    ),
    GetPage(
      name: _Paths.FOURNISSEUR,
      page: () => const FournisseurView(),
      binding: FournisseurBinding(),
    ),
    GetPage(
      name: _Paths.CLIENT,
      page: () => const ClientView(),
      binding: ClientBinding(),
    ),
    GetPage(
      name: _Paths.REFERENCE,
      page: () => const ReferenceView(),
      binding: ReferenceBinding(),
    ),
  ];
}
