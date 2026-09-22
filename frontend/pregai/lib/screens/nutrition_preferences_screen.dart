import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../data/nutrition_store.dart';
import '../models/nutrition_profile.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/section_header.dart';
import 'personalized_diet_plan_screen.dart';

/// Where a patient (or a health worker, on a patient's behalf) enters
/// the inputs that make nutrition guidance personal: food budget,
/// dietary pattern, food preferences, and local food availability.
///
/// These are saved to [NutritionStore] under [patient]'s own ID —
/// never shared with or shown for any other patient — and are the
/// only new data this feature asks for. Everything else the
/// (eventual) rule engine needs — pregnancy stage, ANC vitals,
/// warning signs — already lives on [patient] and is reused as-is.
class NutritionPreferencesScreen extends StatefulWidget {
  final Patient patient;
  const NutritionPreferencesScreen({super.key, required this.patient});

  @override
  State<NutritionPreferencesScreen> createState() => _NutritionPreferencesScreenState();
}

class _NutritionPreferencesScreenState extends State<NutritionPreferencesScreen> {
  FoodBudget? _budget;
  DietaryPattern? _dietaryPattern;
  final Set<String> _foodPreferences = {};
  final Set<String> _locallyAvailableFoods = {};

  String? _errorText;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from any preferences already saved for this patient,
    // so editing doesn't discard what was entered before.
    final existing = NutritionStore.profileFor(widget.patient.id);
    if (existing != null) {
      _budget = existing.budget;
      _dietaryPattern = existing.dietaryPattern;
      _foodPreferences.addAll(existing.foodPreferences);
      _locallyAvailableFoods.addAll(existing.locallyAvailableFoods);
    }
  }

  Future<void> _save() async {
    // Budget and dietary pattern are required — without them the rule
    // engine has nothing to personalize against. Food preferences and
    // local availability are optional refinements.
    if (_budget == null || _dietaryPattern == null) {
      setState(() => _errorText = 'Please select a food budget and dietary pattern to continue.');
      return;
    }

    setState(() {
      _errorText = null;
      _isSaving = true;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    NutritionStore.save(NutritionProfile(
      patientId: widget.patient.id,
      budget: _budget!,
      dietaryPattern: _dietaryPattern!,
      foodPreferences: _foodPreferences.toList(),
      locallyAvailableFoods: _locallyAvailableFoods.toList(),
      updatedAt: DateTime.now(),
    ));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nutrition preferences saved.')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PersonalizedDietPlanScreen(patient: widget.patient)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Preferences')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For ${widget.patient.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Tell us about your food situation so your guidance can be personalized.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(title: 'Food Budget', icon: Icons.currency_rupee_rounded),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: FoodBudget.values.map((budget) {
                  final selected = _budget == budget;
                  return ChoiceChip(
                    label: Text(budget.label),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.white : AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _budget = budget),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(title: 'Dietary Pattern', icon: Icons.restaurant_outlined),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: DietaryPattern.values.map((pattern) {
                  final selected = _dietaryPattern == pattern;
                  return ChoiceChip(
                    label: Text(pattern.label),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.white : AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _dietaryPattern = pattern),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Food Preferences',
                subtitle: 'Select foods you like or prefer',
                icon: Icons.favorite_outline_rounded,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: DummyData.nutritionFoodOptions.map((food) {
                  final selected = _foodPreferences.contains(food);
                  return FilterChip(
                    label: Text(food),
                    selected: selected,
                    showCheckmark: false,
                    avatar: selected
                        ? const Icon(Icons.check_circle, size: 18, color: Colors.white)
                        : null,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _foodPreferences.add(food);
                        } else {
                          _foodPreferences.remove(food);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Local Food Availability',
                subtitle: 'Select foods commonly available to you',
                icon: Icons.storefront_outlined,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: DummyData.nutritionFoodOptions.map((food) {
                  final selected = _locallyAvailableFoods.contains(food);
                  return FilterChip(
                    label: Text(food),
                    selected: selected,
                    showCheckmark: false,
                    avatar: selected
                        ? const Icon(Icons.check_circle, size: 18, color: Colors.white)
                        : null,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _locallyAvailableFoods.add(food);
                        } else {
                          _locallyAvailableFoods.remove(food);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: AppMetrics.spaceM),
                Text(
                  _errorText!,
                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                ),
              ],

              const SizedBox(height: AppMetrics.spaceXL),
              AppButton(
                label: 'Save Preferences',
                icon: Icons.save_outlined,
                isLoading: _isSaving,
                onPressed: _save,
              ),
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
    );
  }
}
