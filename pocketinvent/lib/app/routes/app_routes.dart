part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const AUTH = _Paths.AUTH;
  static const HUB = _Paths.HUB;
  static const HOME = _Paths.HOME;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const TRANSACTIONS = _Paths.TRANSACTIONS;
  static const ADD_PHONE = _Paths.ADD_PHONE;
  static const PHONE_DETAIL = _Paths.PHONE_DETAIL;
  static const FOURNISSEUR = _Paths.FOURNISSEUR;
  static const ADD_FOURNISSEUR = _Paths.ADD_FOURNISSEUR;
  static const CLIENT = _Paths.CLIENT;
  static const ADD_CLIENT = _Paths.ADD_CLIENT;
  static const REFERENCE = _Paths.REFERENCE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HUB = '/hub';
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const TRANSACTIONS = '/transactions';
  static const ADD_PHONE = '/add-phone';
  static const PHONE_DETAIL = '/phone-detail';
  static const FOURNISSEUR = '/fournisseur';
  static const ADD_FOURNISSEUR = '/add-fournisseur';
  static const CLIENT = '/client';
  static const ADD_CLIENT = '/add-client';
  static const REFERENCE = '/reference';
}
