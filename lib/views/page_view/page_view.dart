import '../home/home_view.dart';
import '../shopping_cart_tab/shopping_cart_view.dart';

import '../profile_view/profile_view.dart';

import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  const CustomPageView({Key? key}) : super(key: key);

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      HomeView(),
      ShoppingCartView(),
      ProfileView(),
    ];

    return Scaffold(
        body: SafeArea(
          child: PageView(
            children: _views,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        //  IndexedStack(
        //   children: _views,
        //   index: _selectedIndex,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: "cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "profile",
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }
}
