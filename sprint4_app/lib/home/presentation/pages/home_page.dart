import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
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
                imageLabelResult: data.currentResult, 
                shouldLabelFile: (filePath) async {
                  await _viewModel.upateImageLabelResult(filePath);
                }, 
                onToggleBottomSheet: (shouldToggleBottomSheet) {
                  _viewModel.updateShouldShowBottomSheet(value: shouldToggleBottomSheet);
                }, 
                onSave: () async {
                  // TODO: - Colocar loading

                  await _viewModel.createData();
                  await _viewModel.fetch();
                  _viewModel.resetCurrentResult();
                  _viewModel.updateShouldShowBottomSheet(value: true);
                }, 
                onClose: () {
                  _viewModel.resetCurrentResult();
                }
              ),

              if (data.shouldShowBottomSheet)
                DraggableBottomSheet(
                  expandedContent: ResultsGrid(
                    results: data.results, 
                    isLoading: data.isLoading, 
                    emptyMessage: 'Nenhum resultado encontrado',
                    onRefresh: _viewModel.refreshResults,
                  )
                )
            ],
          ),
        );
      }
    );
  }
}
