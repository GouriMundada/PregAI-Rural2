import 'patient.dart';

/// A single ANC (antenatal care) visit record.
///
/// Patients accumulate a list of these over the course of a pregnancy
/// (see `Patient.ancVisits` / `Patient.copyWithNewVisit`) — each visit
/// is its own historical record and appending a new one never
/// overwrites or removes an earlier one.
class AncVisit {
  final int visitNumber;
  final String visitDate; // dd/mm/yyyy display string, same convention as LMP/EDD elsewhere
  final int gestationalAgeWeeks;

  // BP kept as two separate numeric fields, matching Patient's
  // architecture — never combined into a single "120/80" string.
  final int systolicBP;
  final int diastolicBP;
  final int maternalHeartRate;
  final int fetalHeartRate;

  final double temperature; // °C
  final double hemoglobin; // g/dL
  final UrineProtein urineProtein;

  // Blood glucose is only meaningful together with the measurement
  // type it was taken under, so the two are always stored together.
  final int bloodGlucose; // mg/dL
  final GlucoseMeasurementType glucoseMeasurementType;

  final List<String> symptoms;

  // The five warning/danger signs, tracked individually per visit for
  // the rule-based safety layer.
  final bool decreasedFetalMovement;
  final bool severeHeadacheOrBlurredVision;
  final bool epigastricOrRuqPain;
  final bool vaginalBleeding;
  final bool fluidLeakage;

  final String notes;

  const AncVisit({
    required this.visitNumber,
    required this.visitDate,
    required this.gestationalAgeWeeks,
    required this.systolicBP,
    required this.diastolicBP,
    this.maternalHeartRate = 78,
    this.fetalHeartRate = 140,
    required this.temperature,
    required this.hemoglobin,
    this.urineProtein = UrineProtein.negative,
    required this.bloodGlucose,
    this.glucoseMeasurementType = GlucoseMeasurementType.fasting,
    this.symptoms = const [],
    this.decreasedFetalMovement = false,
    this.severeHeadacheOrBlurredVision = false,
    this.epigastricOrRuqPain = false,
    this.vaginalBleeding = false,
    this.fluidLeakage = false,
    this.notes = '',
  });

  /// Formatted "120/80 mmHg" string. Systolic/diastolic remain
  /// separate numeric fields above — this is display-only.
  String get bloodPressureDisplay => '$systolicBP/$diastolicBP mmHg';

  /// Formatted "36.7°C" string.
  String get temperatureDisplay => '${temperature.toStringAsFixed(1)}°C';

  bool get hasWarningSigns =>
      decreasedFetalMovement ||
      severeHeadacheOrBlurredVision ||
      epigastricOrRuqPain ||
      vaginalBleeding ||
      fluidLeakage;

  List<String> get activeWarningSigns => [
        if (decreasedFetalMovement) 'Decreased Fetal Movement',
        if (severeHeadacheOrBlurredVision) 'Severe Headache/Blurred Vision',
        if (epigastricOrRuqPain) 'Epigastric/RUQ Pain',
        if (vaginalBleeding) 'Vaginal Bleeding',
        if (fluidLeakage) 'Fluid Leakage',
      ];
}
