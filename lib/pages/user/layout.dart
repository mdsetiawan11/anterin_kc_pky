import 'package:flutter/material.dart';

class UserLayout extends StatefulWidget {
  const UserLayout({super.key});

  @override
  State<UserLayout> createState() => _UserLayoutState();
}

class _UserLayoutState extends State<UserLayout> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User'),
    );
  }
}
