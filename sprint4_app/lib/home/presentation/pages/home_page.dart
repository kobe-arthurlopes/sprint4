import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/service/image/image_service_protocol.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';
import 'package:sprint4_app/home/presentation/components/pulsing_button.dart';
import 'package:sprint4_app/home/presentation/components/results/results_grid.dart';
import 'package:sprint4_app/home/presentation/components/draggable_bottom_sheet.dart';
import 'package:sprint4_app/home/presentation/pages/image_description_page.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  static const routeId = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final HomeViewModel _viewModel;
  late final ImageServiceProtocol _imageService;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    _imageService = context.read<ImageServiceProtocol>();
    _initialize();
  }

  Future<void> _initialize() async {
    await _viewModel.fetch();
  }

  Future<void> _pickImage({required ImageSource source}) async {
    _imageService.setSource(source);
    final pickedFiled = await _imageService.pickImage();

    if (pickedFiled == null) return;

    final result = await _viewModel.upateImageLabelResult(
      filePath: pickedFiled.path,
    );

    if (result.file == null) return;

    _goToImageDescriptionPage(result: result);
  }

  void _goToImageDescriptionPage({required ImageLabelResult result}) {
    context.push(
      ImageDescriptionPage.routeId,
      extra: ImageDescriptionArgs(
        imageFile: result.file!,
        predictions: result.predictions,
        onSave: _onDismissImageDescription,
      ),
    );
  }

  Future<void> _onDismissImageDescription() async {
    await _viewModel.createData();
    await _viewModel.fetch();
    _viewModel.resetCurrentResult();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeData>(
      valueListenable: _viewModel.data,
      builder: (_, data, _) {
        return Semantics(
          identifier: 'home',
          child: Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Stack(
              children: [
                SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: 20,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Semantics(
                            identifier: 'home_title',
                            excludeSemantics: true,
                            child: Text(
                              'Tap the button to capture an image from camera',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PulsingButton(
                              onTap: () async {
                                await _pickImage(source: ImageSource.camera);
                              },
                            ),

                            SizedBox(height: 100),

                            Semantics(
                              identifier: 'home_pick_from_gallery',
                              hint: 'tap to open gallery',
                              button: true,
                              child: GestureDetector(
                                onTap: () async {
                                  await _pickImage(source: ImageSource.gallery);
                                },
                                child: Text(
                                  'Pick from gallery',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableBottomSheet(
                    expandedContent: ResultsGrid(
                      results: data.results,
                      isLoading: data.isLoading,
                      emptyMessage: 'No results found',
                      onRefresh: () async {
                        await _viewModel.fetch();
                      },
                      onDelete: (result) async {
                        await _viewModel.deleteResult(result);
                        await _viewModel.fetch(shouldLoad: false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
