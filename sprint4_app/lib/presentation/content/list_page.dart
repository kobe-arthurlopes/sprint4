import 'package:flutter/material.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';
import 'package:sprint4_app/presentation/components/image_labels_list.dart';
import 'package:sprint4_app/presentation/content/list_view_model.dart';

class ListPage extends StatefulWidget {
  final ListViewModel viewModel;
  
  const ListPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ImageLabelResult> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => isLoading = true);
    final data = await widget.viewModel.fetch();
    setState(() {
      results = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text('Resultados Salvos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ImageLabelResultsGrid(
        results: results,
        isLoading: isLoading,
        onRefresh: _loadResults,
        emptyMessage: 'Nenhum resultado encontrado',
      ),
    );
  }
}