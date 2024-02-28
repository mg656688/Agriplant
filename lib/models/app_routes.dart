import 'package:agriplant/main.dart';
import 'package:flutter/material.dart';
import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/pages/services/services_page.dart';
import 'package:agriplant/pages/market/cart_page.dart';

import '../pages/bottom_navigation/bottom_navigation_view.dart';
import '../pages/onboarding_page.dart';


class Routes {
  static const String init = '/';
  static const String auth = '/auth';
  static const String onBoarding = '/onBoarding';
  static const String profilePage = '/profile';
  static const String explorePage = '/explore';
  static const String servicesPage = '/services';
  static const String cartView = '/cart';
  static const String completePurchaseView = '/completePurchase';
}

Map<String, WidgetBuilder> appRoutes = {
  Routes.init: (context) => const BottomNavigationBarView(),
  Routes.auth: (context) => const AuthChecker(),
  Routes.profilePage: (context) => const ProfilePage(),
  Routes.explorePage: (context) =>  const HomePage(),
  Routes.servicesPage: (context) => const ServicesPage(),
  Routes.cartView: (context) => const CartPage(),
  Routes.onBoarding: (context) => const OnboardingPage(),
};
