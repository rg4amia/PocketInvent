import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/hub/hub_binding.dart';
import '../modules/hub/hub_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/transaction/transaction_binding.dart';
import '../modules/transaction/transaction_view.dart';
import '../modules/phone/add_phone_binding.dart';
import '../modules/phone/add_phone_view.dart';
import '../modules/phone/phone_detail_binding.dart';
import '../modules/phone/phone_detail_view.dart';
import '../modules/fournisseur/fournisseur_binding.dart';
import '../modules/fournisseur/fournisseur_view.dart';
import '../modules/fournisseur/add_fournisseur_binding.dart';
import '../modules/fournisseur/add_fournisseur_view.dart';
import '../modules/client/client_binding.dart';
import '../modules/client/client_view.dart';
import '../modules/client/add_client_binding.dart';
import '../modules/client/add_client_view.dart';
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
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.HUB,
      page: () => const HubView(),
      binding: HubBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.TRANSACTIONS,
      page: () => const TransactionView(),
      binding: TransactionBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.ADD_PHONE,
      page: () => const AddPhoneView(),
      binding: AddPhoneBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.PHONE_DETAIL,
      page: () => const PhoneDetailView(),
      binding: PhoneDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.FOURNISSEUR,
      page: () => const FournisseurView(),
      binding: FournisseurBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.ADD_FOURNISSEUR,
      page: () => const AddFournisseurView(),
      binding: AddFournisseurBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.CLIENT,
      page: () => const ClientView(),
      binding: ClientBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.ADD_CLIENT,
      page: () => const AddClientView(),
      binding: AddClientBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.REFERENCE,
      page: () => const ReferenceView(),
      binding: ReferenceBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
