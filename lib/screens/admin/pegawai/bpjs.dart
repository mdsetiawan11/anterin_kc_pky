import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PegawaiBPJS extends StatefulWidget {
  const PegawaiBPJS({super.key});

  @override
  State<PegawaiBPJS> createState() => _PegawaiBPJSState();
}

class _PegawaiBPJSState extends State<PegawaiBPJS> {
  List<UserModel> pegawai = [];

  Future getPegawai() async {
    final response = await http.get(Uri.parse('${apiUrl}allpegawai'));
    var data = jsonDecode(response.body);

    if (data.length > 0) {
      for (var singleData in data) {
        UserModel peg = UserModel(
            id: singleData['id'],
            username: singleData['username'],
            nama: singleData['nama'],
            bagian: singleData['bagian'],
            role: singleData['role']);
        pegawai.add(peg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: getPegawai(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: pegawai.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            pegawai[index].nama,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(pegawai[index].bagian),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
