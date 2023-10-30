import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/permintaan_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PermintaanDriver extends StatefulWidget {
  const PermintaanDriver({super.key});

  @override
  State<PermintaanDriver> createState() => _PermintaanDriverState();
}

class _PermintaanDriverState extends State<PermintaanDriver> {
  String username = '';
  double initialRating = 0.0;
  bool isRatingVisibility = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      username = (localStorage.getString('username') ?? '');
    });
  }

  List<PermintaanModel> permintaans = [];

  Future getPermintaan() async {
    final response =
        await http.get(Uri.parse('${apiUrl}permintaanbydriver/$username'));

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
          tanggalKembali: DateTime.parse(singleData['tanggal_berangkat']),
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

  callback() {
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
        title: const Text('Anterin'),
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
                          child: InkWell(
                            onTap: () {
                              if (permintaans[index].keterangan ==
                                  "disetujui") {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: 'Lapor Sudah Kembali',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    var response = await http.put(
                                      Uri.parse(apiUrl + 'sudah'),
                                      body: {"id": permintaans[index].id},
                                    );

                                    if (response.statusCode == 200) {
                                      callback();
                                      Fluttertoast.showToast(
                                          msg: 'Lapor berhasil');
                                    }
                                  },
                                ).show();
                              }
                            },
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
                                      ),
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
}
