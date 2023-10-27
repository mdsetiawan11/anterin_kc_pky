// To parse this JSON data, do
//
//     final permintaanModel = permintaanModelFromJson(jsonString);

class PermintaanModel {
  String id;
  DateTime tanggalPengajuan;
  String usernamePengaju;
  String namaPengaju;
  String bagianPengaju;
  String hari;
  DateTime tanggalBerangkat;
  String jamBerangkat;
  String jamKembali;
  String tujuan;
  String kegiatan;
  String usernameDriver;
  String keterangan;
  double? skor;
  String? komentar;

  PermintaanModel(
      {required this.id,
      required this.tanggalPengajuan,
      required this.usernamePengaju,
      required this.namaPengaju,
      required this.bagianPengaju,
      required this.hari,
      required this.tanggalBerangkat,
      required this.jamBerangkat,
      required this.jamKembali,
      required this.tujuan,
      required this.kegiatan,
      required this.usernameDriver,
      required this.keterangan,
      required this.skor,
      required this.komentar});
}
