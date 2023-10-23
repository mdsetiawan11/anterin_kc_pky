import 'package:anterin_kc_pky/screens/admin/pegawai/bpjs.dart';
import 'package:anterin_kc_pky/screens/admin/pegawai/driver.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';

class AdminPegawai extends StatefulWidget {
  const AdminPegawai({super.key});

  @override
  State<AdminPegawai> createState() => _AdminPegawaiState();
}

class _AdminPegawaiState extends State<AdminPegawai> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Warna.utama,
            title: const Text('Manajemen Pegawai'),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            bottom: const TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Pegawai',
                  ),
                  Tab(
                    text: 'Driver',
                  )
                ]),
          ),
          body: const TabBarView(children: [PegawaiBPJS(), DriverBPJS()]),
        ));
  }
}
