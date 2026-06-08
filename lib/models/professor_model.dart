class Professor {
  final String name;
  final Map<String, bool?> traits;
  double score;

  Professor({
    required this.name,
    required this.traits,
    this.score = 0.0,
  });

  void reset() {
    score = 0.0;
  }

  Professor copy() {
    return Professor(
      name: name,
      traits: Map<String, bool?>.from(traits),
      score: score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'traits': traits,
      'score': score,
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      name: map['name'] as String,
      traits: Map<String, bool?>.from(map['traits'] as Map),
      score: (map['score'] as num).toDouble(),
    );
  }
}
