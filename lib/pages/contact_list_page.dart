import 'dart:io';

import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/pages/edit_contact_page.dart';
import 'package:contact_list/repositories/contacts_repo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<ContactModel> contacts = [];
  late ContactRepository contactRepo;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    contactRepo = ContactRepository();
    setup();
  }

  setup() async {
    setState(() {
      isLoading = true;
    });
    var response = await contactRepo.list();
    if (response != null) {
      setState(() {
        contacts = response;
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text(
                    'Ocorreu um erro com nossos servidores :(\nPerdão pelo transtorno'),
              ));
    }
    setState(() {
      isLoading = false;
    });
  }

  onPressedDelete(BuildContext context, String objId) async {
    var wasDeleted = await contactRepo.delete(objId);
    if (wasDeleted) {
      setup();
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Contato deletado com sucesso!'),
              ));
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Falha ao deletar contato!'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              contacts.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Não há nenhum contato registrado ainda!'),
                        SizedBox(
                          height: 10,
                        ),
                        FaIcon(FontAwesomeIcons.faceSadCry)
                      ],
                    )
                  : Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, _) => const SizedBox(
                          height: 50,
                        ),
                        itemBuilder: (_, index) {
                          var contact = contacts[index];
                          return SizedBox(
                            height: 80,
                            child: ListTile(
                              onTap: () {
                                Navigator.push<bool?>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EditContactPage(
                                            contact: contact))).then((value) {
                                  if (value != null && value) {
                                    setup();
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(15)),
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nome: ${contact.name}"),
                                  Text("Phone: ${contact.phoneNumber}"),
                                ],
                              ),
                              leading: contact.photoUrl != ""
                                  ? Image.file(File(contact.photoUrl!))
                                  : const FaIcon(FontAwesomeIcons.user),
                              trailing: TextButton(
                                onPressed: () {
                                  onPressedDelete(context, contact.objId);
                                },
                                child: const FaIcon(FontAwesomeIcons.xmark),
                              ),
                            ),
                          );
                        },
                        itemCount: contacts.length,
                      ),
                    ),
            ],
          );
  }
}
