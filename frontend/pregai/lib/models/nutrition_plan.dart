import 'nutrition_profile.dart';

/// One personalized suggestion within a [NutritionPlan]. Every field
/// here — including [explanation] — must be populated by the
/// validated nutrition rule engine; nothing in this app invents the
/// content of a recommendation. See NutritionRuleEngine.
class NutritionRecommendation {
  /// Which part of the day this applies to (e.g. "Breakfast",
  /// "Mid-Morning", "Lunch", "Evening Snack", "Dinner") — the rule
  /// engine determines the meal structure, not this app.
  final String mealContext;

  /// The rule-generated suggestion itself.
  final String suggestion;

  /// A lower-cost/local alternative to [suggestion], if the rule
  /// engine provides one for the patient's budget.
  final String? affordableAlternative;

  /// Why this was suggested. Must come from the validated rule
  /// engine — never generated or guessed by the UI layer.
  final String explanation;

  const NutritionRecommendation({
    required this.mealContext,
    required this.suggestion,
    this.affordableAlternative,
    required this.explanation,
  });
}

/// A patient's personalized nutrition plan, as produced by
/// NutritionRuleEngine.generatePlan. Always tied to one [patientId]
/// and the inputs (budget, dietary pattern, gestational age) it was
/// generated for, so the UI can show why the plan looks the way it
/// does without re-deriving anything itself.
class NutritionPlan {
  final String patientId;
  final int generatedForGestationalAge;
  final FoodBudget budgetCategory;
  final DietaryPattern dietaryPattern;
  final List<NutritionRecommendation> mealSuggestions;

  /// Locally available food options relevant to this plan, as
  /// selected/confirmed by the rule engine from the patient's
  /// [NutritionProfile.locallyAvailableFoods] — not recomputed here.
  final List<String> locallyAvailableOptions;

  final DateTime generatedAt;

  const NutritionPlan({
    required this.patientId,
    required this.generatedForGestationalAge,
    required this.budgetCategory,
    required this.dietaryPattern,
    required this.mealSuggestions,
    this.locallyAvailableOptions = const [],
    required this.generatedAt,
  });
}
