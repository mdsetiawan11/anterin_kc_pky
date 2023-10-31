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
  DateTime tanggalKembali;
  String jamKembali;
  String tujuan;
  String kegiatan;
  String usernameDriver;
  String keterangan;
  String skor;
  String komentar;

  PermintaanModel(
      {required this.id,
      required this.tanggalPengajuan,
      required this.usernamePengaju,
      required this.namaPengaju,
      required this.bagianPengaju,
      required this.hari,
      required this.tanggalBerangkat,
      required this.jamBerangkat,
      required this.tanggalKembali,
      required this.jamKembali,
      required this.tujuan,
      required this.kegiatan,
      required this.usernameDriver,
      required this.keterangan,
      required this.skor,
      required this.komentar});

  factory PermintaanModel.fromJson(Map<String, dynamic> json) {
    return PermintaanModel(
        id: json['id'],
        tanggalPengajuan: DateTime.parse(json['tanggal_pengajuan']),
        usernamePengaju: json['username_pengaju'],
        namaPengaju: json['nama_pengaju'],
        bagianPengaju: json['bagian_pengaju'],
        hari: json['hari'],
        tanggalBerangkat: DateTime.parse(json['tanggal_berangkat']),
        jamBerangkat: json['jam_berangkat'],
        tanggalKembali: DateTime.parse(json['tanggal_kembali']),
        jamKembali: json['jam_kembali'],
        tujuan: json['tujuan'],
        kegiatan: json['kegiatan'],
        usernameDriver: json['username_driver'],
        keterangan: json['keterangan'],
        skor: json['skor'],
        komentar: json['komentar']);
  }
}
