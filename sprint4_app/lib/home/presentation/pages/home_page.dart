import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/image/image_service_protocol.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';
import 'package:sprint4_app/home/presentation/components/results/results_grid.dart';
import 'package:sprint4_app/home/presentation/components/draggable_bottom_sheet.dart';
import 'package:sprint4_app/home/presentation/components/image_picker_widget.dart';
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
  late final bool _isTesting;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    _imageService = context.read<ImageServiceProtocol>();
    _isTesting = context.read<bool>();
    _initialize();
  }

  Future<void> _initialize() async {
    await _viewModel.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeData>(
      valueListenable: _viewModel.data,
      builder: (_, data, _) {
        return Scaffold(
          body: Stack(
            children: [
              ImagePickerWidget(
                service: _imageService,
                imageLabelResult: data.currentResult,
                shouldLabelFile: (filePath) async {
                  await _viewModel.upateImageLabelResult(
                    filePath: filePath,
                    isTesting: _isTesting,
                  );
                },
                onToggleBottomSheet: (shouldToggleBottomSheet) {
                  _viewModel.updateShouldShowBottomSheet(
                    value: shouldToggleBottomSheet,
                  );
                },
                onSave: () async {
                  await _viewModel.createData();
                  await _viewModel.fetch();
                  _viewModel.resetCurrentResult();
                  _viewModel.updateShouldShowBottomSheet(value: true);
                },
                onClose: _viewModel.resetCurrentResult,
              ),

              if (data.currentResult?.file == null)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        'Tap the button to capture a new image',
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

              if (data.shouldShowBottomSheet)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableBottomSheet(
                    expandedContent: ResultsGrid(
                      results: data.results,
                      isLoading: data.isLoading,
                      emptyMessage: 'No results found',
                      onRefresh: _viewModel.refreshResults,
                      onDelete: (result) async {
                        await _viewModel.deleteResult(result);
                        await _viewModel.refreshResults();
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
