import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/image_labeling_channel.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  final _picker = ImagePicker();
  List<LabeledImage>? _labeledImages;

  _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _imageFile = File(pickedImage.path);
      await _setLabeledImages();
      setState(() {});
    }
  }

  _setLabeledImages() async {
    if (_imageFile == null) return;
    _labeledImages = await ImageLabelingChannel.labelImage(_imageFile!.path);
  }

  List<Widget> _getLabeledImagesWidget() {
    if (_labeledImages == null) return [];

    List<Widget> all = [];

    for (var labeledImage in _labeledImages!) {
      all.add(Text(labeledImage.text));
      all.add(Text(labeledImage.confidence));
    }

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker'),),
      body: Column(
        children: [
          Center(
            child: _imageFile == null
              ? const Text('No image selected')
              : Image.file(
                _imageFile!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
          ),

          if (_imageFile != null)
            ..._getLabeledImagesWidget()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(),
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}