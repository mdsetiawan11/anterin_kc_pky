import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';

class AddPermintaanUser extends StatefulWidget {
  const AddPermintaanUser({super.key});

  @override
  State<AddPermintaanUser> createState() => _AddPermintaanUserState();
}

class _AddPermintaanUserState extends State<AddPermintaanUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Ajukan Permintaan Driver'),
        backgroundColor: Warna.utama,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
