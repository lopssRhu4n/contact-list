import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomSheetPhotoPicker extends StatefulWidget {
  final Function() onCameraSelected;
  final Function() onGallerySelected;
  const BottomSheetPhotoPicker(
      {super.key,
      required this.onCameraSelected,
      required this.onGallerySelected});

  @override
  State<BottomSheetPhotoPicker> createState() => _BottomSheetPhotoPickerState();
}

class _BottomSheetPhotoPickerState extends State<BottomSheetPhotoPicker> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
            title: const Text("Camera"),
            trailing: const FaIcon(FontAwesomeIcons.camera),
            onTap: widget.onCameraSelected),
        ListTile(
          title: const Text('Galeria'),
          trailing: const FaIcon(FontAwesomeIcons.images),
          onTap: widget.onGallerySelected,
        )
      ],
    );
  }
}
