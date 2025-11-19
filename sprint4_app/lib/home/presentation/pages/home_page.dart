import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/home/presentation/components/image_picker_widget.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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
    return ImagePickerWidget();

    // return Scaffold(
    //   appBar: AppBar(title: const Text('Home'),),
    //   body: Center(
    //     child: Image.asset(
    //       'images/example_img.jpg',
    //       width: 200,
    //       height: 200,
    //     ),
    //   ),
    // );
  }
}