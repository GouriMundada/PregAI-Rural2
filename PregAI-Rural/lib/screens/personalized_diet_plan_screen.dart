import 'package:flutter/material.dart';
import '../data/nutrition_store.dart';
import '../models/nutrition_plan.dart';
import '../models/nutrition_profile.dart';
import '../models/patient.dart';
import '../services/nutrition_personalization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/section_header.dart';
import 'nutrition_preferences_screen.dart';

/// Shows [patient]'s personalized nutrition guidance.
///
/// This screen never invents content. It reads:
///   1. [patient] — existing Patient/Pregnancy/ANC data, reused as-is.
///   2. The patient's [NutritionProfile] from [NutritionStore], if
///      they've set one up.
///   3. Whatever [NutritionPersonalizationService] (backed today by
///      [UnconnectedNutritionRuleEngine]) returns for those inputs.
///
/// Until the team's validated nutrition rules are connected, step 3
/// always returns null, so this screen shows the honest "not
/// available yet" empty state below the patient's saved preferences
/// — never a fabricated meal plan.
class PersonalizedDietPlanScreen extends StatelessWidget {
  final Patient patient;
  const PersonalizedDietPlanScreen({super.key, required this.patient});

  static const _service = NutritionPersonalizationService();

  @override
  Widget build(BuildContext context) {
    final profile = NutritionStore.profileFor(patient.id);
    final plan = profile == null ? null : _service.buildPlan(patient: patient, profile: profile);

    return Scaffold(
      appBar: AppBar(title: const Text('🥗 Personalized Diet Plan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(patient: patient),
              const SizedBox(height: AppMetrics.spaceM),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppMetrics.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.lightPink,
                  borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.accentRed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is personalized guidance based on your own information — not a generic diet chart.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              if (profile == null)
                _SetupPrompt(patient: patient)
              else ...[
                _PreferencesSummaryCard(patient: patient, profile: profile),
                const SizedBox(height: AppMetrics.spaceL),
                if (plan == null) const _EmptyPlanState() else _PlanContent(plan: plan),
              ],
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Patient patient;
  const _Header({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'For ${patient.name}',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Pregnancy Stage: ${patient.gestationalAgeDisplay}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SetupPrompt extends StatelessWidget {
  final Patient patient;
  const _SetupPrompt({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tune_rounded, color: AppColors.primary, size: 28),
          const SizedBox(height: AppMetrics.spaceM),
          Text('Set up nutrition preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Add a food budget, dietary pattern, and food preferences so guidance can be '
            'personalized for ${patient.name}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppMetrics.spaceM),
          AppButton(
            label: 'Set Up Nutrition Preferences',
            icon: Icons.tune_rounded,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => NutritionPreferencesScreen(patient: patient)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesSummaryCard extends StatelessWidget {
  final Patient patient;
  final NutritionProfile profile;
  const _PreferencesSummaryCard({required this.patient, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Nutrition Preferences', style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NutritionPreferencesScreen(patient: patient)),
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
              ),
            ],
          ),
          const Divider(height: 20),
          _row(context, 'Budget', profile.budget.label),
          _row(context, 'Dietary Pattern', profile.dietaryPattern.label),
          _row(
            context,
            'Food Preferences',
            profile.foodPreferences.isEmpty ? 'None selected' : profile.foodPreferences.join(', '),
          ),
          _row(
            context,
            'Local Availability',
            profile.locallyAvailableFoods.isEmpty
                ? 'None selected'
                : profile.locallyAvailableFoods.join(', '),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}

/// The honest state shown while no validated nutrition rule engine is
/// connected. This is intentionally NOT a generic diet chart and NOT
/// a fabricated plan — see UnconnectedNutritionRuleEngine.
class _EmptyPlanState extends StatelessWidget {
  const _EmptyPlanState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        border: Border.all(color: AppColors.lightPink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.hourglass_empty_rounded, color: AppColors.greyText, size: 28),
          const SizedBox(height: AppMetrics.spaceM),
          Text(
            'Personalized nutrition guidance is not available yet.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Your plan will appear here once the validated nutrition rules are configured. '
            'Your preferences above are already saved and will be used as soon as they are.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PlanContent extends StatelessWidget {
  final NutritionPlan plan;
  const _PlanContent({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Meal Suggestions', icon: Icons.restaurant_menu_rounded),
        ...plan.mealSuggestions.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: AppMetrics.spaceM),
              child: _RecommendationCard(recommendation: rec),
            )),
        if (plan.locallyAvailableOptions.isNotEmpty) ...[
          const SizedBox(height: AppMetrics.spaceM),
          const SectionHeader(title: 'Locally Available Options', icon: Icons.storefront_outlined),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plan.locallyAvailableOptions
                .map((food) => Chip(
                      avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                      label: Text(food),
                      backgroundColor: AppColors.lightPink,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final NutritionRecommendation recommendation;
  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation.mealContext,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(recommendation.suggestion, style: Theme.of(context).textTheme.bodyLarge),
          if (recommendation.affordableAlternative != null) ...[
            const SizedBox(height: 8),
            Text(
              'Affordable alternative: ${recommendation.affordableAlternative}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const Divider(height: 20),
          Text(
            'Why this was suggested',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(recommendation.explanation, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
