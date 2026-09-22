import '../models/nutrition_consideration.dart';
import '../models/nutrition_plan.dart';
import '../models/nutrition_profile.dart';
import '../models/patient.dart';
import 'nutrition_rule_engine.dart';

/// Orchestrates building a [NutritionPlan] for a patient: gathers the
/// existing Patient/Pregnancy/ANC data and the patient's
/// [NutritionProfile], then hands them to a [NutritionRuleEngine].
///
/// This is the one class screens call — they never talk to
/// [NutritionRuleEngine] directly — so swapping in the team's
/// validated rules later (via the constructor's `engine` parameter)
/// never requires touching the UI layer.
class NutritionPersonalizationService {
  final NutritionRuleEngine _engine;

  const NutritionPersonalizationService({
    NutritionRuleEngine engine = const UnconnectedNutritionRuleEngine(),
  }) : _engine = engine;

  /// Builds the plan for [patient] using their saved [profile].
  /// [healthConsiderations] should be whatever the existing validated
  /// rule-based system has produced for this patient — pass an empty
  /// list (the default) until that integration exists; see
  /// NutritionConsideration's doc comment.
  NutritionPlan? buildPlan({
    required Patient patient,
    required NutritionProfile profile,
    List<NutritionConsideration> healthConsiderations = const [],
  }) {
    return _engine.generatePlan(NutritionInput(
      patient: patient,
      profile: profile,
      healthConsiderations: healthConsiderations,
    ));
  }
}
