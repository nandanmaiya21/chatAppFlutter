import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    final _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  void _pickPhoto() async {
    final _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Choose Option',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Choose option to pick image'),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.cancel_outlined)),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {
                _pickImage();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  content: Text('Profile Image Added!'),
                  duration: Duration(seconds: 10),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.filter),
              onPressed: () {
                _pickPhoto();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  content: Text('Profile Image Added!'),
                  duration: Duration(seconds: 10),
                ));
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: _pickedImage == null
              ? Text(
                  'PHOTO',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 30,
                      fontFamily: 'Anton'),
                )
              : Container(),
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _showMyDialog,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
