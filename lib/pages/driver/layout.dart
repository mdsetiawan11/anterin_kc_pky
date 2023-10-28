import 'package:anterin_kc_pky/pages/driver/permintaan.dart';
import 'package:anterin_kc_pky/pages/driver/profil.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class DriverLayout extends StatefulWidget {
  const DriverLayout({super.key});

  @override
  State<DriverLayout> createState() => _DriverLayoutState();
}

class _DriverLayoutState extends State<DriverLayout> {
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Warna.utama,
        onButtonPressed: onButtonPressed,
        iconSize: 25,
        activeColor: Colors.white,
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            icon: Icons.local_taxi,
            title: 'Anterin',
          ),
          BarItem(
            icon: Icons.person_rounded,
            title: 'Profil',
          ),
        ],
      ),
    );
  }
}

List<Widget> _pages = <Widget>[
  const PermintaanDriver(),
  const DriverProfil(),
];
