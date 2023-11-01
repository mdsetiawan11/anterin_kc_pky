import 'package:anterin_kc_pky/shared/colors.dart';
import 'package:flutter/material.dart';

class textFormField extends StatelessWidget {
  final bool isreadOnly;
  final TextEditingController TextController;
  final String labelText;
  final String validatorText;
  final IconData iconData;
  final VoidCallback onTap;
  textFormField({
    super.key,
    required this.isreadOnly,
    required this.TextController,
    required this.labelText,
    required this.validatorText,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: TextController,
      readOnly: isreadOnly,
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          prefixIcon: Icon(iconData),
          prefixIconColor: Warna.utama,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Warna.utama))),
    );
  }
}
