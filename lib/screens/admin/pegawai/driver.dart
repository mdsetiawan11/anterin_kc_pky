import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _nama = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _nama.dispose();
    _password.dispose();
    super.dispose();
  }

  callback() {
    setState(() {
      driver = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Warna.utama,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Tambah Data Driver'),
                    actions: [
                      MaterialButton(
                        color: Warna.utama,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              var response = await http.post(
                                  Uri.parse('${apiUrl}tambahdriver'),
                                  body: {
                                    "username": _username.text.trim(),
                                    "nama": _nama.text.trim(),
                                    "password": _password.text.trim()
                                  });
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: 'Tambah Data Berhasil',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Warna.utama,
                                    textColor: Colors.white);
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'Tambah Data Gagal',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            }
                            _username.clear();
                            _nama.clear();
                            _password.clear();
                          }
                          // ignore: use_build_context_synchronously

                          callback();
                          Navigator.pop(context);
                        },
                        child: const Text('Simpan'),
                      )
                    ],
                    content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _username,
                              decoration:
                                  const InputDecoration(labelText: 'username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'username tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _nama,
                              decoration:
                                  const InputDecoration(labelText: 'nama'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _password,
                              decoration:
                                  const InputDecoration(labelText: 'password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'password tidak boleh kosong';
                                }
                                return null;
                              },
                            )
                          ],
                        )),
                  );
                });
              });
        },
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
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
              }
              if (driver.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data'),
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
