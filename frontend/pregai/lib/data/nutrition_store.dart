import '../models/nutrition_profile.dart';

/// Holds each patient's [NutritionProfile], keyed by patient ID.
///
/// Like DummyData and the rest of this project's mock/local
/// architecture, this is in-memory only (no database/backend) and
/// resets when the app restarts. It exists specifically so nutrition
/// preferences are *patient-specific* rather than living as loose UI
/// state: saving Patient P001's preferences never touches P002's, and
/// reading P002's preferences can never return P001's data.
class NutritionStore {
  NutritionStore._();

  static final Map<String, NutritionProfile> _profilesByPatientId = {};

  /// The saved profile for [patientId], or null if that patient
  /// hasn't set up nutrition preferences yet.
  static NutritionProfile? profileFor(String patientId) => _profilesByPatientId[patientId];

  static bool hasProfile(String patientId) => _profilesByPatientId.containsKey(patientId);

  /// Saves/overwrites [profile] under its own patientId. Never
  /// affects any other patient's entry.
  static void save(NutritionProfile profile) {
    _profilesByPatientId[profile.patientId] = profile;
  }
}
