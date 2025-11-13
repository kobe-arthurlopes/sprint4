import 'package:flutter/material.dart';
import 'package:sprint4_app/home_page.dart';
import 'package:sprint4_app/image_labeling_channel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String imagePath = 'images/example_img.jpg';
  final labeledImages = await ImageLabelingChannel.labelImage(imagePath);
  print(labeledImages);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
