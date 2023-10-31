import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/permintaan_model.dart';
import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:http/http.dart' as http;

class AdminService {
  //get all permintaan
  Future getPermintaan() async {
    final response = await http.get(Uri.parse('${apiUrl}rekap'));

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      List<PermintaanModel> permintaans =
          it.map((e) => PermintaanModel.fromJson(e)).toList();
      return permintaans;
    }
  }

  //get all pegawai bpjs
  Future getPegawai() async {
    final response = await http.get(Uri.parse('${apiUrl}allpegawai'));

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      List<UserModel> pegawai = it.map((e) => UserModel.fromJson(e)).toList();
      return pegawai;
    }
  }

  //get all driver
  Future getDriver() async {
    final response = await http.get(Uri.parse('${apiUrl}alldriver'));

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      List<UserModel> driver = it.map((e) => UserModel.fromJson(e)).toList();
      return driver;
    }
  }

  //add pegawai
  Future addPegawai(
      String username, String nama, String bagian, String password) async {
    try {
      var response = await http.post(
        Uri.parse('${apiUrl}tambahpegawai'),
        body: {
          "username": username,
          "nama": nama,
          "bagian": bagian,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e.toString());
    }
  }
}
