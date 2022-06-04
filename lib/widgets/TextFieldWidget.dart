import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function() uploadFunction;
  final TextInputType textInputType;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.uploadFunction,
    required this.textInputType,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: false,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.cloud_upload,
          ),
          onPressed: widget.uploadFunction,
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: Colors.lightGreen,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            color: Colors.lightGreen,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            color: Colors.lightGreen,
          ),
        ),
      ),
    );
  }
}
