import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PegawaiBPJS extends StatefulWidget {
  const PegawaiBPJS({super.key});

  @override
  State<PegawaiBPJS> createState() => _PegawaiBPJSState();
}

class _PegawaiBPJSState extends State<PegawaiBPJS> {
  List<UserModel> pegawai = [];

  String selectedBagian = 'SDMUK';
  var bagians = [
    'SDMUK',
    'KEPSER',
    'PMU',
    'YANFASKES',
    'YANSER',
    'PKP',
  ];

  Future getPegawai() async {
    final response = await http.get(Uri.parse('${apiUrl}allpegawai'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updateFormkey = GlobalKey<FormState>();
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
      pegawai = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tambah();
        },
        backgroundColor: Warna.utama,
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: getPegawai(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (pegawai.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data'),
                );
              } else {
                return ListView.builder(
                    itemCount: pegawai.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            update(pegawai[index].id, pegawai[index].username,
                                pegawai[index].nama, pegawai[index].bagian);
                          },
                          title: Text(
                            pegawai[index].nama,
                            style: const TextStyle(fontSize: 18),
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

  void tambah() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Data Pegawai'),
              actions: [
                MaterialButton(
                  color: Warna.utama,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var response = await http
                            .post(Uri.parse('${apiUrl}tambahpegawai'), body: {
                          "username": _username.text.trim(),
                          "nama": _nama.text.trim(),
                          "bagian": selectedBagian,
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
                        decoration: const InputDecoration(labelText: 'nama'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                          decoration:
                              const InputDecoration(labelText: 'bagian'),
                          value: selectedBagian,
                          items: bagians.map((String bagians) {
                            return DropdownMenuItem(
                                value: bagians, child: Text(bagians));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBagian = newValue!;
                            });
                          }),
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
          },
        );
      },
    );
  }

  void update(
    String id,
    String username,
    String nama,
    String bagian,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Data Pegawai'),
              actions: [
                MaterialButton(
                  color: Warna.utama,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_updateFormkey.currentState!.validate()) {
                      try {
                        var response = await http
                            .put(Uri.parse('${apiUrl}editpegawai'), body: {
                          "id": id,
                          "nama": _username.text.trim(),
                          "bagian": selectedBagian,
                          "password": _password.text.trim()
                        });
                        print(id);
                        print(nama);
                        print(selectedBagian);
                        print(_password.text.trim());
                        if (response.statusCode == 200) {
                          Fluttertoast.showToast(
                              msg: 'Update Data Berhasil',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Warna.utama,
                              textColor: Colors.white);
                          callback();
                          Navigator.pop(context);
                          _username.clear();
                          _nama.clear();
                          _password.clear();
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'Update Data Gagal',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white);
                      }
                    }
                    // ignore: use_build_context_synchronously
                  },
                  child: const Text('Simpan'),
                )
              ],
              content: Form(
                  key: _updateFormkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _username,
                        readOnly: true,
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
                        controller: TextEditingController(text: nama),
                        decoration: const InputDecoration(labelText: 'nama'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                          decoration:
                              const InputDecoration(labelText: 'bagian'),
                          value: bagian,
                          items: bagians.map((String bagians) {
                            return DropdownMenuItem(
                                value: bagians, child: Text(bagians));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBagian = newValue!;
                            });
                          }),
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
          },
        );
      },
    );
  }
}
