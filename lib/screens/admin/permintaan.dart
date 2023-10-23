import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/permintaan_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AdminPermintaan extends StatefulWidget {
  const AdminPermintaan({super.key});

  @override
  State<AdminPermintaan> createState() => _AdminPermintaanState();
}

class _AdminPermintaanState extends State<AdminPermintaan> {
  List<PermintaanModel> permintaans = [];

  Future getPermintaan() async {
    final response = await http.get(Uri.parse('${apiUrl}rekap'));

    var data = jsonDecode(response.body);
    if (data.length > 0) {
      for (var singleData in data) {
        PermintaanModel permintaan = PermintaanModel(
          id: singleData['id'],
          tanggalPengajuan: DateTime.parse(singleData['tanggal_pengajuan']),
          usernamePengaju: singleData['username_pengaju'],
          namaPengaju: singleData['nama_pengaju'],
          bagianPengaju: singleData['bagian_pengaju'],
          hari: singleData['hari'],
          tanggalBerangkat: DateTime.parse(singleData['tanggal_berangkat']),
          jamBerangkat: singleData['jam_berangkat'],
          jamKembali: singleData['jam_kembali'],
          tujuan: singleData['tujuan'],
          kegiatan: singleData['kegiatan'],
          usernameDriver: singleData['username_driver'],
          namaDriver: singleData['nama_driver'],
          keterangan: singleData['keterangan'],
        );
        permintaans.add(permintaan);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Warna.utama,
        title: const Text('Permintaan Driver'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getPermintaan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: permintaans.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Slidable(
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    approve(permintaans[index].id);
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.check,
                                  label: 'Approve',
                                ),
                              ]),
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    cancel(permintaans[index].id);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.update,
                                  label: 'Cancel',
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Pengajuan'),
                                    Text('Nama Pengaju'),
                                    Text('Bagian Pengaju'),
                                    Text('Hari'),
                                    Text('Tanggal Berangkat'),
                                    Text('Jam Berangkat'),
                                    Text('Jam Kembali'),
                                    Text('Tujuan'),
                                    Text('Kegiatan'),
                                    Text('Nama Driver'),
                                    Text('Keterangan'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        ' : ${permintaans[index].tanggalPengajuan}'),
                                    Text(
                                        ' : ${permintaans[index].namaPengaju}'),
                                    Text(
                                        ' : ${permintaans[index].bagianPengaju}'),
                                    Text(' : ${permintaans[index].hari}'),
                                    Text(
                                        ' : ${permintaans[index].tanggalBerangkat}'),
                                    Text(
                                        ' : ${permintaans[index].jamBerangkat}'),
                                    Text(' : ${permintaans[index].jamKembali}'),
                                    Text(' : ${permintaans[index].tujuan}'),
                                    Text(' : ${permintaans[index].kegiatan}'),
                                    Text(' : ${permintaans[index].namaDriver}'),
                                    Text(' : ${permintaans[index].keterangan}'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }

  void approve(String id) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Setujui Permintaan?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        print(id);
        try {
          var url = Uri.parse('https://anterin.jekaen-pky.com/api/approve/');
          var response = await http.put(
            url,
            body: {
              "id": id,
            },
          );

          if (response.statusCode == 200) {
            setState(() {
              permintaans = [];
            });
            Fluttertoast.showToast(
              msg: 'Permintaan berhasil disetujui',
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Permintaan gagal disetujui, silahkan coba lagi',
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Permintaan gagal disetujui, silahkan coba lagi',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      btnCancelText: 'Batal',
      btnOkText: 'Ya',
    ).show();
  }

  void cancel(String id) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Batalkan Permintaan?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        print(id);
        try {
          var url = Uri.parse('https://anterin.jekaen-pky.com/api/cancel/');
          var response = await http.put(
            url,
            body: {
              "id": id,
            },
          );

          if (response.statusCode == 200) {
            setState(() {
              permintaans = [];
            });
            Fluttertoast.showToast(
              msg: 'Permintaan berhasil dibatalkan',
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Permintaan gagal dibatalkan, silahkan coba lagi',
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Permintaan gagal dibatalkan, silahkan coba lagi',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      btnCancelText: 'Batal',
      btnOkText: 'Ya',
    ).show();
  }
}
