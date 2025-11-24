import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/presentation/components/draggable_bottom_sheet.dart';
import 'package:sprint4_app/presentation/components/image_picker_widget.dart';
import 'package:sprint4_app/presentation/view_models/home_view_model.dart';

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
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                ImagePickerWidget(viewModel: viewModel),
                if (viewModel.showBottomSheet) // ✅ Agora reage às mudanças
                  DraggableBottomSheet(),
              ],
            ),
          );
        },
      ),
    );
  }
}