import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:sprint4_app/common/models/prediction.dart';
import 'package:sprint4_app/home/presentation/components/save_dialog.dart';

class ImageDescriptionArgs {
  final File imageFile;
  final List<Prediction> predictions;
  final Future<void> Function() onSave;

  const ImageDescriptionArgs({
    required this.imageFile,
    required this.predictions,
    required this.onSave,
  });
}

class ImageDescriptionPage extends StatefulWidget {
  static const routeId = '/imageDescription';

  final File imageFile;
  final List<Prediction> predictions;
  final Future<void> Function() onSave;

  const ImageDescriptionPage({
    super.key,
    required this.imageFile,
    required this.predictions,
    required this.onSave,
  });

  @override
  State<StatefulWidget> createState() => _ImageDescriptionPageState();
}

class _ImageDescriptionPageState extends State<ImageDescriptionPage> {
  List<Widget> _getLabeledImagesWidget() {
    if (widget.predictions.isEmpty) return [];

    List<Widget> all = [];

    for (var prediction in widget.predictions) {
      all.add(
        MergeSemantics(
          child: Row(
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
        ),
      );

      all.add(SizedBox(height: 10));
    }

    return all;
  }

  void _showSavingDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => SaveDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CloseButton(color: Colors.white, onPressed: context.pop),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Semantics(
                        label: 'ML Kit labeled image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            excludeFromSemantics: true,
                            widget.imageFile,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [..._getLabeledImagesWidget()],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _showSavingDialog(context);
                    await widget.onSave();

                    if (!context.mounted) return;

                    Navigator.of(context).pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Semantics(
                    identifier: 'image_description_save_button',
                    label: 'save',
                    hint:
                        'double tap to save labeled image and its predictions',
                    excludeSemantics: true,
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
