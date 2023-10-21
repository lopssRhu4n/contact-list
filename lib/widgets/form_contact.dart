// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/repositories/contacts_repo.dart';
import 'package:contact_list/widgets/photo_picker_bottom_sheet.dart';
import 'package:contact_list/widgets/text_input_with_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ContactForm extends StatefulWidget {
  final ContactModel? model;
  const ContactForm({super.key, this.model});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late ContactRepository contactRepo;
  XFile? photo;
  var photoUrlController = TextEditingController();
  var instaController = TextEditingController();
  var facebookController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  bool isRequired(TextEditingController c) {
    return c.text != "";
  }

  void onCameraSelected() async {
    final ImagePicker picker = ImagePicker();
    photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      String path =
          (await path_provider.getApplicationDocumentsDirectory()).path;

      var completePath = path + basename(photo!.path);
      await photo!.saveTo(completePath);
      // ignore: use_build_context_synchronously
      await GallerySaver.saveImage(photo!.path);

      setState(() {
        photoUrlController.text = photo!.path;
      });
    }
  }

  void onGallerySelected() async {
    final ImagePicker picker = ImagePicker();
    photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        photoUrlController.text = photo!.path;
      });
    }
  }

  void onSubmitCreation(BuildContext context) async {
    if (isRequired(nameController) && isRequired(phoneController)) {
      var data = {
        "name": nameController.text,
        "phoneNumber": int.parse(phoneController.text),
        "facebookUser": facebookController.text,
        "instagramUser": instaController.text,
        "photoUrl": photoUrlController.text
      };
      var model = await contactRepo.save(data);
      if (model != null) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Text('Contato salvo corretamente!'),
                ));
        Navigator.of(context).pop(true);
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Os campos Telefone e Nome são obrigatórios!'),
              ));
    }
  }

  void onSubmitUpdate(BuildContext context) async {
    var data = arrangeUpdateData();
    var wasUpdated = await contactRepo.update(widget.model!.objId, data);
    if (wasUpdated) {
      showDialog(
          context: context,
          builder: (_) =>
              const AlertDialog(content: Text('Contato atualizado!')));
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Não foi possível atualizar o contato'),
              ));
      Navigator.pop(context);
    }
  }

  Map<String, dynamic> arrangeUpdateData() {
    var data = <String, dynamic>{};
    if (nameController.text != "") {
      data['name'] = nameController.text;
    }
    if (phoneController.text != "") {
      data['phoneNumber'] = int.parse(phoneController.text);
    }
    if (instaController.text != "") {
      data['instagramUser'] = instaController.text;
    }
    if (facebookController.text != "") {
      data['facebookUser'] = facebookController.text;
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    contactRepo = ContactRepository();
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      phoneController.text = widget.model!.phoneNumber.toString();
      instaController.text = widget.model!.instagramUser ?? "";
      facebookController.text = widget.model!.facebookUser ?? "";

      if (widget.model!.photoUrl != null) {
        photoUrlController.text = widget.model!.photoUrl!;
        photo = XFile(photoUrlController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            photoUrlController.text == ""
                ? TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(45)))),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => BottomSheetPhotoPicker(
                              onCameraSelected: onCameraSelected,
                              onGallerySelected: onGallerySelected));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: FaIcon(FontAwesomeIcons.user),
                    ))
                : TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => BottomSheetPhotoPicker(
                              onCameraSelected: onCameraSelected,
                              onGallerySelected: onGallerySelected));
                    },
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.file(File(photo!.path))),
                  ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Adicionar foto',
              style: TextStyle(fontSize: 10, color: Colors.deepPurple),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.model != null
                ? 'Editar contato: ${widget.model!.name}'
                : 'Criar novo contato!'),
            const SizedBox(
              height: 20,
            ),
            TextInputWithIcon(
                text: 'Nome',
                textController: nameController,
                icon: FontAwesomeIcons.user),
            const SizedBox(
              height: 30,
            ),
            TextInputWithIcon(
              text: 'Telefone',
              textController: phoneController,
              icon: FontAwesomeIcons.phone,
              textType: TextInputType.phone,
            ),
            const SizedBox(
              height: 30,
            ),
            TextInputWithIcon(
                text: 'Contato do Instagram',
                textController: instaController,
                icon: FontAwesomeIcons.instagram),
            const SizedBox(
              height: 30,
            ),
            TextInputWithIcon(
                text: 'Contato do Facebook',
                textController: facebookController,
                icon: FontAwesomeIcons.facebook),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => widget.model != null
                        ? onSubmitUpdate(context)
                        : onSubmitCreation(context),
                    child: const Text('Enviar'))
              ],
            )
          ],
        ),
      )
    ]);
  }
}
