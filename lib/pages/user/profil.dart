import 'package:anterin_kc_pky/pages/auth/intro.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfil extends StatefulWidget {
  const UserProfil({super.key});

  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  String nama = '';
  String bagian = '';

  final Uri _url = Uri.parse('https://www.instagram.com/md.setiawan11/');

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('username');
    localStorage.remove('nama');
    localStorage.remove('role');
    localStorage.remove('bagian');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const IntroductionPage()));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      nama = (localStorage.getString('nama') ?? '');
      bagian = (localStorage.getString('bagian') ?? '');
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Warna.utama,
      ),
      body: Column(
        children: [
          Container(
            color: Warna.utama,
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset('assets/man.png'),
                  ),
                ),
                Text(
                  nama,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  bagian,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              shape: Border.all(color: Warna.kedua),
              elevation: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MaterialButton(
                      onPressed: () {},
                      child: ListTile(
                        leading: const Icon(
                          Icons.privacy_tip,
                          color: Warna.kedua,
                        ),
                        title: Text(
                          'Privacy Policy',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        shape: const Border(
                          bottom: BorderSide(color: Warna.kedua),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Dialogs.materialDialog(
                          color: Colors.white,
                          title: 'based on flutter develop by mdsdev',
                          context: context,
                          actions: [
                            IconsButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: 'Ok',
                              color: Colors.grey,
                              textStyle: const TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                            IconsButton(
                              onPressed: () {
                                _launchUrl();
                              },
                              text: 'Instagram',
                              iconData: FontAwesomeIcons.instagram,
                              color: Colors.pink,
                              textStyle: const TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ],
                          lottieBuilder: Lottie.asset(
                            'assets/dev.json',
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.logo_dev,
                          color: Warna.kedua,
                        ),
                        title: Text(
                          'Developer Info',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        shape: const Border(
                          bottom: BorderSide(color: Warna.kedua),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Dialogs.materialDialog(
                            msg: 'Are you sure want to logout?',
                            title: "Logout",
                            color: Colors.white,
                            context: context,
                            actions: [
                              IconsOutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'Cancel',
                                iconData: Icons.cancel_outlined,
                                textStyle: const TextStyle(color: Colors.grey),
                                iconColor: Colors.grey,
                              ),
                              IconsButton(
                                onPressed: () {
                                  logout();
                                },
                                text: 'Yes',
                                iconData: Icons.logout,
                                color: Colors.red,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ]);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Warna.kedua,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        shape: const Border(
                          bottom: BorderSide(color: Warna.kedua),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Versi 1.0.0',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
