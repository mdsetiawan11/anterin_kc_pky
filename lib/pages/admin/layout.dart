import 'package:anterin_kc_pky/pages/admin/dashboard.dart';
import 'package:anterin_kc_pky/pages/admin/pegawai.dart';
import 'package:anterin_kc_pky/pages/admin/permintaan.dart';
import 'package:anterin_kc_pky/pages/admin/profil.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';

import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
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
            icon: Icons.dashboard_rounded,
            title: 'Dashboard',
          ),
          BarItem(
            icon: Icons.checklist_rounded,
            title: 'Permintaan',
          ),
          BarItem(
            icon: Icons.group_rounded,
            title: 'Pegawai',
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
  const AdminDashboard(),
  const AdminPermintaan(),
  const AdminPegawai(),
  const AdminProfil()
];
