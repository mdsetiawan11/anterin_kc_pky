import 'package:flutter/material.dart';

class DriverLayout extends StatefulWidget {
  const DriverLayout({super.key});

  @override
  State<DriverLayout> createState() => _DriverLayoutState();
}

class _DriverLayoutState extends State<DriverLayout> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Driver'),
    );
  }
}
