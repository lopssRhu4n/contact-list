import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextInputWithIcon extends StatefulWidget {
  final String text;
  final TextEditingController textController;
  final IconData icon;
  final TextInputType? textType;

  const TextInputWithIcon(
      {super.key,
      required this.text,
      required this.textController,
      required this.icon,
      this.textType});

  @override
  State<TextInputWithIcon> createState() => _TextInputWithIconState();
}

class _TextInputWithIconState extends State<TextInputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 10, color: Colors.deepPurple),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.deepPurple)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.deepPurple)),
          label: Row(
            children: [
              FaIcon(widget.icon),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.text,
                style: const TextStyle(color: Colors.deepPurple),
                // style: const TextStyle(fontSize: 10),
              ),
            ],
          )),
      keyboardType: widget.textType ?? TextInputType.text,
    );
  }
}
