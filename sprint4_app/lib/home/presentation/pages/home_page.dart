import 'package:flutter/material.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';
import 'package:sprint4_app/home/presentation/components/results/results_grid.dart';
import 'package:sprint4_app/home/presentation/components/draggable_bottom_sheet.dart';
import 'package:sprint4_app/home/presentation/components/image_picker_widget.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await widget.viewModel.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeData>(
      valueListenable: widget.viewModel.data, 
      builder: (_, data, _) {
        return Scaffold(
          body: Stack(
            children: [
              ImagePickerWidget(
                imageLabelResult: data.currentResult, 
                shouldLabelFile: (filePath) async {
                  await widget.viewModel.upateImageLabelResult(filePath);
                }, 
                onToggleBottomSheet: (shouldToggleBottomSheet) {
                  widget.viewModel.updateShouldShowBottomSheet(value: shouldToggleBottomSheet);
                }, 
                onSave: () async {
                  // TODO: - Colocar loading

                  await widget.viewModel.createData();
                  await widget.viewModel.fetch();
                  widget.viewModel.resetCurrentResult();
                  widget.viewModel.updateShouldShowBottomSheet(value: true);
                }, 
                onClose: () {
                  widget.viewModel.resetCurrentResult();
                }
              ),

              if (data.shouldShowBottomSheet)
                DraggableBottomSheet(
                  expandedContent: ResultsGrid(
                    results: data.results, 
                    isLoading: data.isLoading, 
                    emptyMessage: 'Nenhum resultado encontrado',
                    onRefresh: widget.viewModel.refreshResults,
                  )
                )
            ],
          ),
        );
      }
    );
  }
}
