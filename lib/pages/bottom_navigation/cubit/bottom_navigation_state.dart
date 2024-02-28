part of 'bottom_navigation_cubit.dart';

abstract class BottomNavigationState {}

class BottomNavigationLoaded extends BottomNavigationState {
  List<Widget> pages;
  final int page;
  BottomNavigationLoaded(
      {this.page = 0,
      this.pages = const [
        HomePage(),
        ServicesPage(),
        CartPage(),
        ProfilePage()
      ]});
}
