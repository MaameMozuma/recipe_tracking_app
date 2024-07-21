class Step {
  final String stepNumber;
  final String description;

  Step({
    required this.stepNumber,
    required this.description,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNumber: json.keys.first,
      description: json.values.first,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      stepNumber: description,
    };
  }
}
