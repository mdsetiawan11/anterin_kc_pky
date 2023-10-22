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
  String namaDriver;
  String keterangan;

  PermintaanModel({
    required this.id,
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
    required this.namaDriver,
    required this.keterangan,
  });

  factory PermintaanModel.fromJson(Map<String, dynamic> json) {
    return PermintaanModel(
      id: json["id"],
      tanggalPengajuan: DateTime.parse(json["tanggal_pengajuan"]),
      usernamePengaju: json["username_pengaju"],
      namaPengaju: json["nama_pengaju"],
      bagianPengaju: json["bagian_pengaju"],
      hari: json["hari"],
      tanggalBerangkat: DateTime.parse(json["tanggal_berangkat"]),
      jamBerangkat: json["jam_berangkat"],
      jamKembali: json["jam_kembali"],
      tujuan: json["tujuan"],
      kegiatan: json["kegiatan"],
      usernameDriver: json["username_driver"],
      namaDriver: json["nama_driver"],
      keterangan: json["keterangan"],
    );
  }
}
