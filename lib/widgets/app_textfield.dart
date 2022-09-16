import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.color,
    required this.obsecure,
    required this.keyboardType,
    required this.autoFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final Color color;
  final bool obsecure;
  final TextInputType keyboardType;
  final bool autoFocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          autofocus: widget.autoFocus,
          autocorrect: false,
          obscureText: widget.obsecure,
          style: const TextStyle(
            color: Colors.black,
          ),
          cursorColor: Colors.black,
          keyboardType: widget.keyboardType,
          textCapitalization: TextCapitalization.sentences,
          controller: widget.controller,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: widget.color),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: widget.color,
                width: 2,
              ),
            ),
            labelText: widget.labelText,
          ),
        ),
      ),
    );
  }
}
