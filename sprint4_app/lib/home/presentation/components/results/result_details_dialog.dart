import 'package:flutter/material.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';

class ResultDetailsDialog extends StatelessWidget {
  final ImageLabelResult result;
  final VoidCallback onDelete;

  const ResultDetailsDialog({
    super.key,
    required this.result,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1E1E1E),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem grande
            if (result.file != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  result.file!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(height: 24),

            // Título
            Text(
              'Predictions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            // Lista de predições com scroll se necessário
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: result.predictions
                      .map(
                        (prediction) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  prediction.label.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              Text(
                                '${(prediction.confidenceDecimal * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Botão fechar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
