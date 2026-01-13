part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const AUTH = _Paths.AUTH;
  static const HOME = _Paths.HOME;
  static const ADD_PHONE = _Paths.ADD_PHONE;
  static const PHONE_DETAIL = _Paths.PHONE_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
  static const ADD_PHONE = '/add-phone';
  static const PHONE_DETAIL = '/phone-detail';
}
