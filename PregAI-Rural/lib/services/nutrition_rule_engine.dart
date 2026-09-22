import '../models/nutrition_consideration.dart';
import '../models/nutrition_plan.dart';
import '../models/nutrition_profile.dart';
import '../models/patient.dart';

/// Everything the nutrition rule engine needs to personalize guidance
/// for one patient, assembled from data the app already has —
/// nothing here is re-entered by the patient.
///
/// [patient] carries the existing Patient/Pregnancy/ANC fields
/// (LMP, gestational age, EDD, gravidity, parity, pregnancy type,
/// previous preeclampsia/GDM/C-section, and the latest recorded
/// vitals — BP, heart rate, weight, temperature, hemoglobin, urine
/// protein, blood glucose + type, symptoms, and the five warning
/// signs). [profile] carries the patient's nutrition-specific inputs
/// (budget, dietary pattern, food preferences, local availability).
/// [healthConsiderations] carries whatever structured output the
/// *existing validated rule-based system* has produced — see
/// NutritionConsideration's doc comment for why this is empty today.
class NutritionInput {
  final Patient patient;
  final NutritionProfile profile;
  final List<NutritionConsideration> healthConsiderations;

  const NutritionInput({
    required this.patient,
    required this.profile,
    this.healthConsiderations = const [],
  });
}

/// The single integration point for the team's validated nutrition
/// rules.
///
/// TO CONNECT THE REAL RULES: write a new class implementing
/// [generatePlan] with the validated logic (or the code that calls
/// out to wherever that logic lives), and pass an instance of it into
/// NutritionPersonalizationService's constructor. No other file in
/// this feature — the preferences screen, the plan screen, the
/// store — needs to change.
abstract class NutritionRuleEngine {
  /// Returns the personalized plan, or `null` if no validated plan
  /// can be produced yet. Returning `null` is the expected, correct
  /// behavior when the rule set isn't connected — callers must show
  /// the "not available yet" empty state in that case, never a
  /// fabricated plan.
  NutritionPlan? generatePlan(NutritionInput input);
}

/// The engine actually wired into the app today.
///
/// The validated Yati/team nutrition rule set has not been integrated
/// yet, so this always returns `null`. That is intentional: per the
/// project's medical-safety requirements, PregAI Rural must never
/// invent meal suggestions, "why this was suggested" explanations, or
/// any other nutrition/medical content. The Personalized Diet Plan
/// screen shows a clearly-worded "not available yet" empty state
/// instead — see screens/personalized_diet_plan_screen.dart.
class UnconnectedNutritionRuleEngine implements NutritionRuleEngine {
  const UnconnectedNutritionRuleEngine();

  @override
  NutritionPlan? generatePlan(NutritionInput input) => null;
}
