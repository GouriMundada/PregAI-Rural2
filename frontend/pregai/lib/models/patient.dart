/// Risk classification used throughout the UI.
/// Kept as an enum so backend integration later can simply map
/// a real ML/risk-engine result onto these same three values.
enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }
}

/// Static/dummy patient model. In a future integration, this same
/// shape can be backed by a database or API response.
///
/// NOTE ON DATA GRANULARITY:
/// Blood pressure and blood glucose are intentionally stored as separate,
/// specific fields (rather than one combined string) because the backend
/// and downstream risk/ML logic need each value independently:
///   - systolicBP / diastolicBP instead of a single "BP" string
///   - bloodGlucose + glucoseMeasurementType instead of a bare "sugar" value
class Patient {
  final String id;
  final String name;
  final int age;
  final String phone;
  final String address;
  final String preferredLanguage;

  // Obstetric history
  final int gravidity; // total number of pregnancies, including current
  final int parity; // previous births (viable deliveries)
  final PregnancyType pregnancyType;
  final bool previousPreeclampsia;
  final bool previousGestationalDiabetes;
  final bool previousCSection;

  final String lmp;
  final String gestationalAge;
  final String edd; // calculated from LMP (Naegele's rule), not manually entered
  final String lastAncVisit;

  // Vitals — BP kept as separate systolic/diastolic values throughout,
  // not a combined "120/80" string, so each can be validated/used on its own.
  final int systolicBP;
  final int diastolicBP;
  final int maternalHeartRate; // bpm
  final int fetalHeartRate; // bpm
  final String weight;
  final double temperature; // °F

  // Labs
  final String hemoglobin;
  final UrineProtein urineProtein;
  final int bloodGlucose; // mg/dL
  final GlucoseMeasurementType glucoseMeasurementType;

  final RiskLevel riskLevel;
  final List<String> symptoms;

  // Warning / danger signs — tracked individually so each can trigger
  // its own alert logic on the backend rather than being buried in
  // free-text notes.
  final bool decreasedFetalMovement;
  final bool severeHeadacheOrBlurredVision;
  final bool epigastricOrRuqPain;
  final bool vaginalBleeding;
  final bool fluidLeakage;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.address,
    this.preferredLanguage = 'English',
    this.gravidity = 1,
    this.parity = 0,
    this.pregnancyType = PregnancyType.singleton,
    this.previousPreeclampsia = false,
    this.previousGestationalDiabetes = false,
    this.previousCSection = false,
    required this.lmp,
    required this.gestationalAge,
    required this.edd,
    required this.lastAncVisit,
    required this.systolicBP,
    required this.diastolicBP,
    this.maternalHeartRate = 78,
    this.fetalHeartRate = 140,
    required this.weight,
    this.temperature = 98.6,
    required this.hemoglobin,
    this.urineProtein = UrineProtein.negative,
    required this.bloodGlucose,
    this.glucoseMeasurementType = GlucoseMeasurementType.fasting,
    required this.riskLevel,
    this.symptoms = const [],
    this.decreasedFetalMovement = false,
    this.severeHeadacheOrBlurredVision = false,
    this.epigastricOrRuqPain = false,
    this.vaginalBleeding = false,
    this.fluidLeakage = false,
  });

  /// Display-only combined BP string, e.g. "120/80 mmHg".
  /// The underlying systolic/diastolic values remain separate.
  String get bloodPressureDisplay => '$systolicBP/$diastolicBP mmHg';

  /// Any of the five danger-sign flags is true.
  bool get hasWarningSigns =>
      decreasedFetalMovement ||
      severeHeadacheOrBlurredVision ||
      epigastricOrRuqPain ||
      vaginalBleeding ||
      fluidLeakage;

  List<String> get activeWarningSigns => [
        if (decreasedFetalMovement) 'Decreased Fetal Movement',
        if (severeHeadacheOrBlurredVision) 'Severe Headache / Blurred Vision',
        if (epigastricOrRuqPain) 'Epigastric / RUQ Pain',
        if (vaginalBleeding) 'Vaginal Bleeding',
        if (fluidLeakage) 'Fluid Leakage',
      ];
}

enum PregnancyType { singleton, twinsOrMore }

extension PregnancyTypeX on PregnancyType {
  String get label {
    switch (this) {
      case PregnancyType.singleton:
        return 'Singleton';
      case PregnancyType.twinsOrMore:
        return 'Twins / Multiple';
    }
  }
}

enum UrineProtein { negative, trace, plus1, plus2, plus3, plus4 }

extension UrineProteinX on UrineProtein {
  String get label {
    switch (this) {
      case UrineProtein.negative:
        return 'Negative';
      case UrineProtein.trace:
        return 'Trace';
      case UrineProtein.plus1:
        return '1+';
      case UrineProtein.plus2:
        return '2+';
      case UrineProtein.plus3:
        return '3+';
      case UrineProtein.plus4:
        return '4+';
    }
  }
}

enum GlucoseMeasurementType { fasting, random, twoHourPostGlucose }

extension GlucoseMeasurementTypeX on GlucoseMeasurementType {
  String get label {
    switch (this) {
      case GlucoseMeasurementType.fasting:
        return 'Fasting';
      case GlucoseMeasurementType.random:
        return 'Random';
      case GlucoseMeasurementType.twoHourPostGlucose:
        return '2-Hour Post-Glucose';
    }
  }
}
