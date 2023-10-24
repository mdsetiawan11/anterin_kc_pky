import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverBPJS extends StatefulWidget {
  const DriverBPJS({super.key});

  @override
  State<DriverBPJS> createState() => _DriverBPJSState();
}

class _DriverBPJSState extends State<DriverBPJS> {
  List<UserModel> driver = [];

  Future getDriver() async {
    final response = await http.get(Uri.parse('${apiUrl}alldriver'));
    var data = jsonDecode(response.body);

    if (data.length > 0) {
      for (var singleData in data) {
        UserModel peg = UserModel(
            id: singleData['id'],
            username: singleData['username'],
            nama: singleData['nama'],
            bagian: singleData['bagian'],
            role: singleData['role']);
        driver.add(peg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: getDriver(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: driver.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            driver[index].nama,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
