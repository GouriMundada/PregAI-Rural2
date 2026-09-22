/// A structured fact the project's *existing validated rule-based
/// system* has flagged as relevant to nutrition — e.g. restating that
/// a warning sign was recorded, not a nutrition recommendation in
/// itself. This class only ever carries whatever that validated
/// engine emits.
///
/// IMPORTANT: nothing in this file invents medical content. The
/// project's current rule engine (see risk_assessment_screen.dart /
/// risk_result_screen.dart) is a frontend demonstration that assigns
/// each dummy patient a fixed [RiskLevel] — it does not yet emit
/// structured, itemized considerations like this. Until it (or the
/// team's validated nutrition rule set) does, callers should pass an
/// empty list; see NutritionInput.healthConsiderations.
class NutritionConsideration {
  final String code;
  final String title;
  final String description;

  const NutritionConsideration({
    required this.code,
    required this.title,
    required this.description,
  });
}
