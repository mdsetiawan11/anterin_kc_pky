import 'dart:convert';

import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:anterin_kc_pky/shared/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPermintaanUser extends StatefulWidget {
  const AddPermintaanUser({super.key});

  @override
  State<AddPermintaanUser> createState() => _AddPermintaanUserState();
}

class _AddPermintaanUserState extends State<AddPermintaanUser> {
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _datebackController = TextEditingController();
  final TextEditingController _timebackController = TextEditingController();

  int currentStep = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTimeBack = TimeOfDay.now();
  List drivers = [];
  var selectedDriver;
  bool isCompleted = false;
  bool isDriverVisibility = false;

  String selectedHari = 'Senin';
  String username = '';
  String nama = '';
  String bagian = '';

  var harilist = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _tujuanController.dispose();
    _kegiatanController.dispose();
    _datebackController.dispose();
    _timebackController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    getProfil();
    super.initState();
  }

  getProfil() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      username = (localStorage.getString('username') ?? '');
      nama = (localStorage.getString('nama') ?? '');
      bagian = (localStorage.getString('bagian') ?? '');
    });
  }

  List<Step> stepList() => [
        Step(
            isActive: currentStep >= 0,
            state: currentStep <= 0 ? StepState.editing : StepState.complete,
            title: const Text('Tanggal dan Jam Berangkat'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKeys[0],
                child: Column(
                  children: [
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: 'Hari Berangkat',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            prefixIconColor: Warna.utama,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Warna.utama))),
                        value: selectedHari,
                        items: harilist.map((String hari) {
                          return DropdownMenuItem(
                              value: hari, child: Text(hari));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHari = newValue!;
                          });
                        }),
                    const SizedBox(
                      height: 20,
                    ),
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
                          return 'Jam berangkat tidak boleh kosong';
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
                  ],
                ),
              ),
            )),
        Step(
            isActive: currentStep >= 1,
            state: currentStep <= 1 ? StepState.editing : StepState.complete,
            title: Text('Driver'),
            content: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: formKeys[1],
                child: Visibility(
                  visible: isDriverVisibility ? true : false,
                  child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Driver tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Driver',
                          filled: true,
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Warna.utama,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Warna.utama))),
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
                ),
              ),
            )),
        Step(
            isActive: currentStep >= 2,
            state: currentStep <= 2 ? StepState.editing : StepState.complete,
            title: const Text('Tujuan dan Kegiatan'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKeys[2],
                child: Column(
                  children: [
                    TextFormField(
                      controller: _tujuanController,
                      readOnly: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tujuan tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Tujuan',
                          filled: true,
                          prefixIcon: Icon(Icons.pin_drop),
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
                      controller: _kegiatanController,
                      readOnly: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Kegiatan tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Kegiatan',
                          filled: true,
                          prefixIcon: Icon(Icons.directions_walk),
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
                      controller: _datebackController,
                      readOnly: true,
                      onTap: () {
                        _selectDateBack();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tanggal kembali tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Tanggal Kembali',
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
                      controller: _timebackController,
                      readOnly: true,
                      onTap: () {
                        _selectbackTime();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jam kembali tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Jam Kembali (Perkiraan)',
                          filled: true,
                          prefixIcon: Icon(Icons.access_time),
                          prefixIconColor: Warna.utama,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Warna.utama))),
                    ),
                  ],
                ),
              ),
            )),
        Step(
            isActive: currentStep >= 3,
            state: StepState.complete,
            title: const Text('Konfirmasi'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKeys[3],
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
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
                    TextFormField(
                      controller: _tujuanController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Tujuan',
                          filled: true,
                          prefixIcon: Icon(Icons.pin_drop),
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
                      controller: _kegiatanController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Kegiatan',
                          filled: true,
                          prefixIcon: Icon(Icons.directions_walk),
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
                      controller: _timebackController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Jam Kembali (Perkiraan)',
                          filled: true,
                          prefixIcon: Icon(Icons.access_time),
                          prefixIconColor: Warna.utama,
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Warna.utama))),
                    ),
                  ],
                ),
              ),
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
            final isLastStep = currentStep == stepList().length - 1;
            final isFirstStep = currentStep == stepList().length - 4;
            if (!formKeys[currentStep].currentState!.validate()) {
              return;
            }
            if (isFirstStep) {
              _getDriver(_dateController.text, _timeController.text);
            }

            if (isLastStep) {
              setState(() {
                isCompleted = true;
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                body: Column(
                  children: [
                    const Text(
                      'Konfirmasi Pengajuan Driver',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('Hari Berangkat : $selectedHari'),
                    Text('Tanggal Berangkat : ${_dateController.text}'),
                    Text('Jam Berangkat : ${_timeController.text}'),
                    Text('Tujuan : ${_tujuanController.text}'),
                    Text('Kegiatan : ${_kegiatanController.text}'),
                    Text('Tanggal Kembali : ${_datebackController.text}'),
                    Text('Jam Kembali : ${_timebackController.text}'),
                    Text('Driver : $selectedDriver'),
                  ],
                ),
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  permintaanPost(
                      selectedHari,
                      _dateController.text,
                      _timeController.text,
                      _tujuanController.text,
                      _kegiatanController.text,
                      _datebackController.text,
                      _timebackController.text,
                      selectedDriver);
                },
              ).show();
            } else {
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

  Future<void> _selectDateBack() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      _datebackController.text = picked.toString().split(" ")[0];
    }
  }

  Future<void> _selectbackTime() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTimeBack,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
                useMaterial3: false,
                colorScheme: const ColorScheme.light(primary: Warna.utama)),
            child: child!,
          );
        });

    if (picked != null) {
      selectedTimeBack = picked;
      _timebackController.text =
          '${selectedTimeBack.hour}:${selectedTimeBack.minute}';
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
          isDriverVisibility = true;
        });
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            msg: '${drivers.length} Driver Tersedia');
      } else {
        Fluttertoast.showToast(msg: 'Tidak ada driver tersedia');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Tidak ada driver tersedia');
    }
  }

  void permintaanPost(
      String hari,
      String tanggalBerangkat,
      String jamBerangkat,
      String tujuan,
      String kegiatan,
      String tanggalKembali,
      String jamKembali,
      String usernameDriver) async {
    try {
      var response = await http.post(Uri.parse('${apiUrl}permintaan'), body: {
        "username": username,
        "nama": nama,
        "bagian": bagian,
        "hari": hari,
        "tanggal_berangkat": tanggalBerangkat,
        "jam_berangkat": jamBerangkat,
        "tujuan": tujuan,
        "kegiatan": kegiatan,
        "tanggal_kembali": tanggalKembali,
        "jam_kembali": jamKembali,
        "username_driver": usernameDriver
      });
      if (response.statusCode == 200) {
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: 'Pengajuan driver berhasil',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Pengajuan driver gagal',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
    print(username);
    print(nama);
    print(bagian);
    print(hari);
    print(tanggalBerangkat);
    print(jamBerangkat);
    print(tujuan);
    print(kegiatan);
    print(jamKembali);
    print(usernameDriver);
  }
}
