import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/widgets/form_contact.dart';
import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final ContactModel contact;
  const EditContactPage({
    super.key,
    required this.contact,
  });

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar contato!'),
      ),
      body: ContactForm(
        model: widget.contact,
      ),
    );
  }
}
