import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Warna.utama,
        title: const Text('Dashboard'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
