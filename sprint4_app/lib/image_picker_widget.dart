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
  ImageSource _imageSource = ImageSource.gallery;

  _pickImage() async {
    final pickedImage = await _picker.pickImage(source: _imageSource);

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
      all.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labeledImage.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),

          Text(
            labeledImage.confidence,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          )
        ],
      ));

      all.add(SizedBox(height: 10));
    }

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image picker')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: _imageFile == null
            ? Center(
              child: const Text(
                'No image selected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.file(
                      _imageFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 20),

                  ..._getLabeledImagesWidget()
                ],
              ),
            )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() => _imageSource = ImageSource.camera);
                _pickImage();
              },
              child: Icon(Icons.camera_alt),
            ),
        
            FloatingActionButton(
              onPressed: () {
                setState(() => _imageSource = ImageSource.gallery);
                _pickImage();
              },
              child: Icon(Icons.photo),
            )
          ],
        ),
      ),
    );
  }
}