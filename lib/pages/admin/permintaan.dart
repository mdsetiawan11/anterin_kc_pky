import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/permintaan_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
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
          tanggalKembali: DateTime.parse(singleData['tanggal_kembali']),
          jamKembali: singleData['jam_kembali'],
          tujuan: singleData['tujuan'],
          kegiatan: singleData['kegiatan'],
          usernameDriver: singleData['username_driver'],
          keterangan: singleData['keterangan'],
          skor: singleData['skor'],
          komentar: singleData['komentar'],
        );
        permintaans.add(permintaan);
      }
    }
  }

  Future refresh() async {
    setState(() {
      permintaans = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Warna.utama,
        title: const Text('Permintaan Driver'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getPermintaan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (permintaans.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data'),
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      (permintaans[index].keterangan ==
                                              "permintaan")
                                          ? Card(
                                              color: Colors.orange,
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  permintaans[index].keterangan,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : (permintaans[index].keterangan ==
                                                  "batal")
                                              ? Card(
                                                  color: Colors.red,
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      permintaans[index]
                                                          .keterangan,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : (permintaans[index]
                                                          .keterangan ==
                                                      "sudah kembali")
                                                  ? Card(
                                                      color: Warna.utama,
                                                      elevation: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          permintaans[index]
                                                              .keterangan,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      elevation: 0,
                                                      color: Colors.green,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          permintaans[index]
                                                              .keterangan,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Tanggal Pengajuan'),
                                          Text('Nama Pengaju'),
                                          Text('Bagian Pengaju'),
                                          Text('Hari'),
                                          Text('Tanggal Berangkat'),
                                          Text('Jam Berangkat'),
                                          Text('Tanggal Kembali'),
                                          Text('Jam Kembali'),
                                          Text('Tujuan'),
                                          Text('Kegiatan'),
                                          Text('Nama Driver'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              ' : ${permintaans[index].tanggalPengajuan.toString().substring(0, 10)}'),
                                          Text(
                                              ' : ${permintaans[index].namaPengaju}'),
                                          Text(
                                              ' : ${permintaans[index].bagianPengaju}'),
                                          Text(' : ${permintaans[index].hari}'),
                                          Text(
                                              ' : ${permintaans[index].tanggalBerangkat.toString().substring(0, 10)}'),
                                          Text(
                                              ' : ${permintaans[index].jamBerangkat}'),
                                          Text(
                                              ' : ${permintaans[index].tanggalKembali.toString().substring(0, 10)}'),
                                          Text(
                                              ' : ${permintaans[index].jamKembali}'),
                                          Text(
                                              ' : ${permintaans[index].tujuan}'),
                                          Text(
                                              ' : ${permintaans[index].kegiatan}'),
                                          Text(
                                              ' : ${permintaans[index].usernameDriver}'),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: (permintaans[index].keterangan ==
                                            "sudah kembali")
                                        ? true
                                        : false,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'Penilaian',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue:
                                                permintaans[index].komentar,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Warna.utama))),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          RatingBar.builder(
                                            initialRating: double.parse(
                                                permintaans[index].skor),
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            ignoreGestures: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ),
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
