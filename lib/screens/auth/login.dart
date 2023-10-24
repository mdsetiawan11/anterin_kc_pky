// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:anterin_kc_pky/screens/admin/layout.dart';
import 'package:anterin_kc_pky/screens/driver/layout.dart';
import 'package:anterin_kc_pky/screens/user/layout.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = true;
  bool isLoading = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future login() async {
    try {
      var url = Uri.parse('${apiUrl}login');
      var response = await http.post(
        url,
        body: {
          "username": _username.text.trim(),
          "password": _password.text.trim(),
        },
      );
      var data = jsonDecode(response.body);
      print(data);
      if (data == "Username atau Password salah.") {
        return Fluttertoast.showToast(
            msg: 'Username atau password salah',
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      } else {
        final localStorage = await SharedPreferences.getInstance();
        await localStorage.setString("username", data['username']);
        await localStorage.setString("nama", data['nama']);
        await localStorage.setString("role", data['role']);
        await localStorage.setString("bagian", data['bagian']);

        if (data['role'] == 'driver') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DriverLayout()));
        } else if (data['role'] == 'user') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const UserLayout()));
        } else if (data['role'] == 'admin') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminLayout()));
        }
        Fluttertoast.showToast(
            msg: 'Selamat datang di Anterin KC PKY',
            backgroundColor: Warna.utama,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      return Fluttertoast.showToast(
          msg: 'Username atau password salah',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Warna.utama,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ClipPath(
                  clipper: WaveClipperOne(flip: true, reverse: true),
                  child: Container(
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      SvgPicture.asset(
                        'assets/login.svg',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextField(
                          controller: _username,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            label: Text('Username'),
                            icon: Icon(
                              Icons.person,
                              color: Warna.utama,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextField(
                          controller: _password,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            icon: const Icon(
                              Icons.lock,
                              color: Warna.utama,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Warna.utama,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });

                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                                login();
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Warna.kedua,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //InkWell(
                      // onTap: () {},
                      // child: const Text('Lupa Password ?'),
                      //)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
