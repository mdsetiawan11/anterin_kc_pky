class UserModel {
  String id;
  String username;
  String nama;
  String bagian;
  String role;

  UserModel(
      {required this.id,
      required this.username,
      required this.nama,
      required this.bagian,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        username: json['username'],
        nama: json['nama'],
        bagian: json['bagian'],
        role: json['role']);
  }
}
