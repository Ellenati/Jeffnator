class Question {
  final String id;
  final String text;

  Question({
    required this.id,
    required this.text,
  });

  Question copyWith({
    String? id,
    String? text,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }
}
