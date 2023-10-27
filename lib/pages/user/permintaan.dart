import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/permintaan_model.dart';
import 'package:anterin_kc_pky/pages/user/add_permintaan.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PermintaanUser extends StatefulWidget {
  const PermintaanUser({super.key});

  @override
  State<PermintaanUser> createState() => _PermintaanUserState();
}

class _PermintaanUserState extends State<PermintaanUser> {
  String username = '';
  double initialRating = 0.0;
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
        await http.get(Uri.parse('${apiUrl}permintaanbyuser/$username'));

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
  void dispose() {
    _comment.dispose();

    super.dispose();
  }

  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Warna.utama,
        title: const Text('Permintaan Driver'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Warna.utama,
          child: const Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddPermintaanUser()));
          }),
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
                                    dialogType: DialogType.noHeader,
                                    body: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Gimana rasanya dianterin pak ${permintaans[index].usernameDriver} ?',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              initialRating = rating;
                                              print(initialRating);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Tulis masukan kamu dibawah ya',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: TextField(
                                              controller: _comment,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Warna.utama))),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              var response = await http.put(
                                                  Uri.parse(apiUrl + 'review'),
                                                  body: {
                                                    "id": permintaans[index].id,
                                                    "skor": double.parse(
                                                        initialRating
                                                            .toString()),
                                                    "komentar": _comment.text
                                                  });
                                              if (response.statusCode == 200) {
                                                initialRating = 0.0;
                                                _comment.clear();
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Terimakasih atas reviewnya yaa!',
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              } else {
                                                Fluttertoast.showToast(
                                                    backgroundColor: Colors.red,
                                                    msg:
                                                        'Oops! review gagal terkirim',
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            },
                                            color: Warna.utama,
                                            textColor: Colors.white,
                                            child: const Text('Kirim'),
                                          )
                                        ],
                                      ),
                                    )).show();
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
                                              : Card(
                                                  elevation: 0,
                                                  color: Colors.green,
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
