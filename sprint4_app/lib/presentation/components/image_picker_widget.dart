import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';
import 'package:sprint4_app/common/service/image_labeling_service.dart';
import 'package:sprint4_app/presentation/components/pulsing_button.dart';
import 'package:sprint4_app/presentation/view_models/home_view_model.dart';

class ImagePickerWidget extends StatefulWidget {
  final HomeViewModel viewModel;
  const ImagePickerWidget({super.key, required this.viewModel});
  @override
  State<StatefulWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  ImageLabelResult imageLabelResult = ImageLabelResult();
  final _picker = ImagePicker();
  ImageSource _imageSource = ImageSource.camera;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Toque o botão')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: imageLabelResult.file == null
            ? GestureDetector(
              onTap:() {
                widget.viewModel.hideBottomSheet();
                _pickImage();
              },
              child: PulsingButton()
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          child: SizedBox(
                            width: 40,
                            child: Icon(Icons.close),
                          ),
                          onTap: () => setState(() {
                            imageLabelResult.file = null;
                            widget.viewModel.appearBottomSheet();
                          }),
                        )
                      ],
                    ),
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
        child: imageLabelResult.file == null 
        ? SizedBox() 
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'heroTag1',
              onPressed: () {
                _imageSource = ImageSource.camera;
                _pickImage();
              },
              child: Icon(Icons.camera_alt),
            ),
    
            FloatingActionButton(
              heroTag: 'heroTag2',
              onPressed: () {
                setState(() => _imageSource = ImageSource.gallery);
                _pickImage();
              },
              child: Icon(Icons.photo),
            ),
            FloatingActionButton(
              heroTag: 'heroTag3',
              onPressed: () async {
                await widget.viewModel.repository.createData(imageLabelResult);
                context.go('/list');
              },
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
