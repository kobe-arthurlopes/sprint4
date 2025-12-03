import 'package:flutter/material.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/home/presentation/components/results/result_card.dart';
import 'package:sprint4_app/home/presentation/components/results/result_details_dialog.dart';

class ResultsGrid extends StatefulWidget {
  final List<ImageLabelResult> results;
  final bool isLoading;
  final String emptyMessage;
  final VoidCallback? onRefresh;
  final void Function(ImageLabelResult) onDelete;

  const ResultsGrid({
    super.key,
    required this.results,
    required this.isLoading,
    required this.emptyMessage,
    this.onRefresh,
    required this.onDelete,
  });

  @override
  State<ResultsGrid> createState() => _ResultsGridState();
}

class _ResultsGridState extends State<ResultsGrid> {
  late List<ImageLabelResult> _results;

  @override
  void initState() {
    super.initState();

    _results = widget.results;
  }

  void _showDetailsDialog(
    BuildContext context,
    ImageLabelResult result,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => ResultDetailsDialog(
        result: result,
        index: index,
        onDelete: (index) {
          _results.removeAt(index);
          setState(() {});
          widget.onDelete(result);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey),

            SizedBox(height: 16),

            Text(
              widget.emptyMessage,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      child: Semantics(
        label: 'you have ${_results.length} results',
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _results.length,
          itemBuilder: (context, index) {
            final result = _results[index];
        
            return Semantics(
              label: 'labeled image number ${index + 1}',
              hint: 'double tap for details',
              excludeSemantics: true,
              child: ResultCard(
                result: result,
                onTap: () => _showDetailsDialog(context, result, index),
              ),
            );
          },
        ),
      ),
    );
  }
}
