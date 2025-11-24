import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/presentation/components/pulsing_button.dart';

class ImagePickerWidget extends StatefulWidget {
  final ImageLabelResult imageLabelResult;
  final void Function(String) shouldLabelFile;
  final void Function(bool) onToggleBottomSheet;
  final void Function() onSave;
  final void Function() onClose;

  const ImagePickerWidget({
    super.key,
    required this.imageLabelResult,
    required this.shouldLabelFile,
    required this.onToggleBottomSheet,
    required this.onSave,
    required this.onClose,
  });

  @override
  State<StatefulWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final _picker = ImagePicker();
  ImageSource _imageSource = ImageSource.camera;

  _pickImage() async {
    final pickedImage = await _picker.pickImage(source: _imageSource);

    if (pickedImage != null) {
      widget.shouldLabelFile(pickedImage.path);
      setState(() {});
    }
  }

  List<Widget> _getLabeledImagesWidget() {
    if (widget.imageLabelResult.predictions.isEmpty) return [];

    List<Widget> all = [];

    for (var prediction in widget.imageLabelResult.predictions) {
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
        child: widget.imageLabelResult.file == null
            ? PulsingButton(
                onTap: () {
                  widget.onToggleBottomSheet(false);
                  _pickImage();
                },
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),

                        CloseButton(
                          onPressed: () {
                            widget.onClose();
                            widget.onToggleBottomSheet(true);
                          },
                        ),
                      ],
                    ),

                    Center(
                      child: Image.file(
                        widget.imageLabelResult.file!,
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
        child: widget.imageLabelResult.file == null
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: 'fab_camera',
                    onPressed: () {
                      setState(() => _imageSource = ImageSource.camera);
                      _pickImage();
                    },
                    child: Icon(Icons.camera_alt),
                  ),

                  FloatingActionButton(
                    heroTag: 'fab_gallery',
                    onPressed: () {
                      setState(() => _imageSource = ImageSource.gallery);
                      _pickImage();
                    },
                    child: Icon(Icons.photo),
                  ),

                  FloatingActionButton(
                    heroTag: 'fab_save',
                    onPressed: () async {
                      widget.onSave();
                      // context.go('/list');
                    },
                    child: Icon(Icons.save),
                  ),
                ],
              ),
      ),
    );
  }
}
