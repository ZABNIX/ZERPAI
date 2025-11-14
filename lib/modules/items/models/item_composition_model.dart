// FILE: lib/modules/items/models/item_composition_model.dart

class ItemComposition {
  final String? content; // Paracetamol, Ibuprofen, etc.
  final String? strength; // 500, 650, etc.
  final String? unit; // mg, ml, etc.
  final String? schedule; // H, H1, Narcotic, etc.

  ItemComposition({this.content, this.strength, this.unit, this.schedule});

  ItemComposition copyWith({
    String? content,
    String? strength,
    String? unit,
    String? schedule,
  }) {
    return ItemComposition(
      content: content ?? this.content,
      strength: strength ?? this.strength,
      unit: unit ?? this.unit,
      schedule: schedule ?? this.schedule,
    );
  }

  // OPTIONAL: For API later
  factory ItemComposition.fromJson(Map<String, dynamic> json) {
    return ItemComposition(
      content: json['content'],
      strength: json['strength'],
      unit: json['unit'],
      schedule: json['schedule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'strength': strength,
      'unit': unit,
      'schedule': schedule,
    };
  }
}
