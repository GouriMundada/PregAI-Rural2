import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A tappable card representing one login mode (ASHA/Health Worker or
/// Doctor). The selected card is visually distinguished by border,
/// shadow, background tint, icon color, and a checkmark indicator.
class ModeSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const ModeSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lightPink : AppColors.white,
      borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        splashColor: AppColors.lightPink,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppMetrics.spaceM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.lightPink,
              width: selected ? 2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: selected ? 0.18 : 0.06),
                blurRadius: selected ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.lightPink,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: selected ? AppColors.white : AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppMetrics.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: selected ? AppColors.primary : AppColors.darkText,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: AppMetrics.spaceS),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.primary : AppColors.greyText,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
