import 'dart:convert';

import 'package:anterin_kc_pky/models/admin/user_model.dart';
import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddPermintaanUser extends StatefulWidget {
  const AddPermintaanUser({super.key});

  @override
  State<AddPermintaanUser> createState() => _AddPermintaanUserState();
}

class _AddPermintaanUserState extends State<AddPermintaanUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  int currentStep = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  List drivers = [];
  var selectedDriver;
  List<Step> stepList() => [
        Step(
            isActive: currentStep >= 0,
            state: currentStep <= 0 ? StepState.editing : StepState.complete,
            title: const Text('Cek Ketersediaan Driver'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () {
                        _selectDate();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tanggal Berangkat tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Tanggal Berangkat',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today),
                          prefixIconColor: Warna.utama,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Warna.utama))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () {
                        _selectTime();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jam Berangkat tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Jam Berangkat',
                          filled: true,
                          prefixIcon: Icon(Icons.access_time),
                          prefixIconColor: Warna.utama,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Warna.utama))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Warna.utama,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _getDriver(
                              _dateController.text, _timeController.text);
                          print(_dateController);
                          print(_timeController);
                        }
                      },
                      child: const Text('Cek'),
                    ),
                    DropdownButtonFormField(
                        decoration: const InputDecoration(labelText: 'Driver'),
                        value: selectedDriver,
                        items: drivers.map((item) {
                          return DropdownMenuItem(
                              value: item['username'].toString(),
                              child: Text(item['nama'].toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedDriver = newValue!;
                          });
                        }),
                  ],
                ),
              ),
            )),
        Step(
            isActive: currentStep >= 1,
            state: currentStep <= 1 ? StepState.editing : StepState.complete,
            title: const Text('Tujuan dan Kegiatan'),
            content: const Center(
              child: Text('Konfirmasi'),
            )),
        Step(
            isActive: currentStep >= 2,
            state: StepState.complete,
            title: const Text('Konfirmasi'),
            content: const Center(
              child: Text('Konfirmasi'),
            )),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Ajukan Permintaan Driver'),
        backgroundColor: Warna.utama,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Warna.utama)),
        child: Stepper(
          steps: stepList(),
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < (stepList().length - 1)) {
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep -= 1;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      _dateController.text = picked.toString().split(" ")[0];
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
                useMaterial3: false,
                colorScheme: const ColorScheme.light(primary: Warna.utama)),
            child: child!,
          );
        });

    if (picked != null) {
      selectedTime = picked;
      _timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
    }
  }

  Future<void> _getDriver(String tanggal, String jam) async {
    try {
      final response = await http.post(
        Uri.parse('${apiUrl}avail'),
        body: {
          "tanggal_berangkat": tanggal,
          "jam_berangkat": jam,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          drivers = data;
        });
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            msg: '${drivers.length} Driver Tersedia');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Tidak ada driver tersedia');
    }
  }
}
