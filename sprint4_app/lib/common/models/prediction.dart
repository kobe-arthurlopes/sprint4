import 'package:sprint4_app/common/models/label.dart';

class Prediction {
  final String id;
  final Label label;
  final double confidenceDecimal;
  final String confidenceText;

  Prediction({
    String? id,
    Label? label,
    required this.confidenceDecimal,
    required this.confidenceText,
  }) : id = id ?? '', label = label ?? Label();

  factory Prediction.fromImageLabelingMap(Map<String, dynamic> map) {
    final labelIndex = map['index'];
    final labelText = map['text'];
    final Label label = Label(id: labelIndex, text: labelText);
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';

    return Prediction(
      label: label,
      confidenceDecimal: confidenceDecimal,
      confidenceText: confidenceText,
    );
  }

  factory Prediction.fromDBMap(Map<String, dynamic> map) {
    final id = map['id'];
    final label = map['label'] ?? Label();
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';

    return Prediction(
      id: id,
      label: label, 
      confidenceDecimal: confidenceDecimal, 
      confidenceText: confidenceText
    );
  }
}