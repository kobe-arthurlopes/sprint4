import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/home/presentation/components/pulsing_button.dart';

class ImagePickerWidget extends StatefulWidget {
  final ImageLabelResult imageLabelResult;
  final void Function(String) shouldLabelFile;
  final void Function(bool) onToggleBottomSheet;
  final void Function() onSave;
  final void Function() onClose;

  ImagePickerWidget({
    super.key,
    ImageLabelResult? imageLabelResult,
    required this.shouldLabelFile,
    required this.onToggleBottomSheet,
    required this.onSave,
    required this.onClose,
  }) : imageLabelResult = imageLabelResult ?? ImageLabelResult();

  @override
  State<StatefulWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final _picker = ImagePicker();
  ImageSource _imageSource = ImageSource.camera;
  final bool isLoading = false;

  _pickImage() async {
    final pickedImage = await _picker.pickImage(source: _imageSource);

    if (pickedImage == null) {
      widget.onToggleBottomSheet(true);
      return;
    }

    widget.shouldLabelFile(pickedImage.path);
  }

  List<Widget> _getLabeledImagesWidget() {
    final result = widget.imageLabelResult;

    if (result.predictions.isEmpty) return [];

    List<Widget> all = [];

    for (var prediction in result.predictions) {
      all.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prediction.label.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              prediction.confidenceText,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
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
      backgroundColor: Color(0xFF121212),
      body: Stack(
        children: [
          widget.imageLabelResult.file == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PulsingButton(
                    onTap: () {
                      widget.onToggleBottomSheet(false);
                      _pickImage();
                    },
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Spacer(),

                              CloseButton(
                                color: Colors.white,
                                onPressed: () {
                                  widget.onClose();
                                  widget.onToggleBottomSheet(true);
                                  _imageSource = ImageSource.camera;
                                  setState(() {});
                                },
                              ),

                              SizedBox(width: 6),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          blurRadius: 14,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        widget.imageLabelResult.file!,
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                ..._getLabeledImagesWidget(),

                                SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
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
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    heroTag: 'fab_camera',
                    onPressed: () {
                      setState(() => _imageSource = ImageSource.camera);
                      _pickImage();
                    },
                    child: Icon(Icons.camera_alt),
                  ),

                  FloatingActionButton(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    heroTag: 'fab_gallery',
                    onPressed: () {
                      setState(() => _imageSource = ImageSource.gallery);
                      _pickImage();
                    },
                    child: Icon(Icons.photo),
                  ),

                  FloatingActionButton(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    heroTag: 'fab_save',
                    onPressed: () async {
                      widget.onSave();
                    },
                    child: Icon(Icons.save),
                  ),
                ],
              ),
      ),
    );
  }
}
