/// Food budget category selected by the patient/health worker.
/// Deliberately has no medical meaning of its own — it exists only so
/// a future validated nutrition rule engine can pick affordable
/// options for the right budget band.
enum FoodBudget { low, medium, higher }

extension FoodBudgetX on FoodBudget {
  String get label {
    switch (this) {
      case FoodBudget.low:
        return 'Low';
      case FoodBudget.medium:
        return 'Medium';
      case FoodBudget.higher:
        return 'Higher';
    }
  }
}

/// Dietary pattern. Kept to the two categories the project currently
/// specifies; extend this enum (not a free-text field) if the team's
/// nutrition rule set later requires more.
enum DietaryPattern { vegetarian, nonVegetarian }

extension DietaryPatternX on DietaryPattern {
  String get label {
    switch (this) {
      case DietaryPattern.vegetarian:
        return 'Vegetarian';
      case DietaryPattern.nonVegetarian:
        return 'Non-vegetarian';
    }
  }
}

/// A single patient's nutrition-personalization inputs — the
/// structured data the (future) validated nutrition rule engine will
/// read, never medical conclusions in themselves. Always associated
/// with exactly one [patientId]; see NutritionStore for how these are
/// kept isolated per patient.
class NutritionProfile {
  final String patientId;
  final FoodBudget budget;
  final DietaryPattern dietaryPattern;

  /// Foods the patient likes/prefers, as structured category values
  /// (see DummyData.nutritionFoodOptions) — never free text, so the
  /// rule engine can match against a known vocabulary.
  final List<String> foodPreferences;

  /// Foods commonly available/affordable to the patient locally —
  /// same structured vocabulary as [foodPreferences].
  final List<String> locallyAvailableFoods;

  final DateTime updatedAt;

  const NutritionProfile({
    required this.patientId,
    required this.budget,
    required this.dietaryPattern,
    this.foodPreferences = const [],
    this.locallyAvailableFoods = const [],
    required this.updatedAt,
  });

  NutritionProfile copyWith({
    FoodBudget? budget,
    DietaryPattern? dietaryPattern,
    List<String>? foodPreferences,
    List<String>? locallyAvailableFoods,
    DateTime? updatedAt,
  }) {
    return NutritionProfile(
      patientId: patientId,
      budget: budget ?? this.budget,
      dietaryPattern: dietaryPattern ?? this.dietaryPattern,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      locallyAvailableFoods: locallyAvailableFoods ?? this.locallyAvailableFoods,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
