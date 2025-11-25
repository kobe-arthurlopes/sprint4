class Label {
  final int id;
  final String text;

  Label({int? id, String? text})
    : id = id ?? 0, text = text ?? '';

  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
      id: map['id'], 
      text: map['text']
    );
  }
}