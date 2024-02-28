import 'package:agriplant/pages/market/cart_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/pages/services/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';


import '../../home_page.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationLoaded());
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(IconlyLight.home),
      label: "Home",
      activeIcon: Icon(IconlyBold.home),
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconlyLight.call),
      label: "Services",
      activeIcon: Icon(IconlyBold.call),
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconlyLight.buy),
      label: "Cart",
      activeIcon: Icon(IconlyBold.buy),
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconlyLight.profile),
      label: "Profile",
      activeIcon: Icon(IconlyBold.profile),
    ),
  ];

  void changeIndex(int index) {
    emit(BottomNavigationLoaded(page: index));
  }
}
