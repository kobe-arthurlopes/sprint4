import 'package:flutter/material.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/presentation/components/results/result_card.dart';

class ResultsListPage extends StatefulWidget {
  final List<ImageLabelResult> results;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const ResultsListPage({
    super.key, 
    required this.results, 
    required this.isLoading,
    this.onRefresh
  });

  @override
  State<ResultsListPage> createState() => _ResultsListPageState();
}

class _ResultsListPageState extends State<ResultsListPage> {
  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    if (widget.onRefresh != null) widget.onRefresh!();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }

    if (widget.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey),

            SizedBox(height: 16),

            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ), 
        itemCount: widget.results.length,
        itemBuilder: (context, index) {
          final result = widget.results[index];

          return ResultCard(
            result: result, 
            onTap: () {

            }
          );
        }
      ), 
    );

    // Se tem callback de refresh, envolve com RefreshIndicator
    // if (onRefresh != null) {
    //   return RefreshIndicator(
    //     onRefresh: () async => onRefresh!(),
    //     color: Colors.blue,
    //     child: gridView,
    //   );
    // }
  }
}