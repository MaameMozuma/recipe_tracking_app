class Ingredient {
  final double? calories;
  final String? quantity;
  final String item;

  Ingredient({
    this.calories,
    this.quantity,
    required this.item,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      item: json['item'],
      quantity: json['quantity'],
      // Ensuring the calories are always parsed as a double
      calories: (json['calories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (calories != null) 'calories': calories,
      if (quantity != null) 'quantity': quantity,
      'item': item,
    };
  }
}
