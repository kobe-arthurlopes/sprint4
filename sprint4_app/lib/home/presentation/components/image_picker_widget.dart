import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/common/service/image_labeling_service.dart';
import 'package:sprint4_app/home/presentation/components/pulsing_button.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  ImageLabelResult imageLabelResult = ImageLabelResult();
  final _picker = ImagePicker();
  ImageSource _imageSource = ImageSource.gallery;

  _pickImage() async {
    final pickedImage = await _picker.pickImage(source: _imageSource);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      imageLabelResult = await ImageLabelingService.getLabeledImage(imageFile);

      setState(() {});
    }
  }

  List<Widget> _getLabeledImagesWidget() {
    if (imageLabelResult.predictions.isEmpty) return [];

    List<Widget> all = [];

    for (var prediction in imageLabelResult.predictions) {
      all.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prediction.label.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              prediction.confidenceText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );

      all.add(SizedBox(height: 10));
    }

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Image picker')),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: imageLabelResult.file == null
              ? PulsingButton()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.file(
                          imageLabelResult.file!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
      
                      SizedBox(height: 20),
      
                      ..._getLabeledImagesWidget(),
                    ],
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed:
                  _pickImage,
                child: Icon(Icons.camera_alt),
              ),
      
              FloatingActionButton(
                onPressed: () {
                  setState(() => _imageSource = ImageSource.gallery);
                  _pickImage();
                },
                child: Icon(Icons.photo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
