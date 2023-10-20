import 'package:anterin_kc_pky/screens/admin/layout.dart';
import 'package:anterin_kc_pky/screens/auth/login.dart';
import 'package:anterin_kc_pky/screens/driver/layout.dart';
import 'package:anterin_kc_pky/screens/user/layout.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var role = (localStorage.getString('role') ?? '');
  runApp(MyApp(role: role));
}

class MyApp extends StatelessWidget {
  final String role;

  const MyApp({super.key, required this.role});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Warna.utama),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: role == ""
            ? const LoginPage()
            : role == "driver"
                ? const DriverLayout()
                : role == "user"
                    ? const UserLayout()
                    : role == "admin"
                        ? const AdminLayout()
                        : const AdminLayout());
  }
}
