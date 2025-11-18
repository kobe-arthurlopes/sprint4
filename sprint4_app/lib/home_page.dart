import 'package:flutter/material.dart';
import 'package:sprint4_app/image_picker_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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