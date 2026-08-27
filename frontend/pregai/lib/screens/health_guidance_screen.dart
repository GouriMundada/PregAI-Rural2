import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';

class _GuidanceTopic {
  final String title;
  final IconData icon;
  final String content;
  final bool isWarning;

  const _GuidanceTopic({
    required this.title,
    required this.icon,
    required this.content,
    this.isWarning = false,
  });
}

const _topics = [
  _GuidanceTopic(
    title: 'Nutrition',
    icon: Icons.restaurant_outlined,
    content:
        'Maintain a balanced diet containing vegetables, fruits, whole grains and adequate protein. '
        'Small, frequent meals can help manage nausea and maintain energy levels throughout the day.',
  ),
  _GuidanceTopic(
    title: 'Hydration',
    icon: Icons.water_drop_outlined,
    content:
        'Maintain adequate fluid intake unless a healthcare professional advises otherwise. '
        'Staying hydrated supports healthy circulation and can help reduce swelling and fatigue.',
  ),
  _GuidanceTopic(
    title: 'ANC Visits',
    icon: Icons.event_available_outlined,
    content:
        'Regular antenatal care visits allow early detection of complications. '
        'Attend every scheduled visit and keep track of vitals, weight, and lab results over time.',
  ),
  _GuidanceTopic(
    title: 'Warning Signs',
    icon: Icons.warning_amber_rounded,
    content:
        'Seek medical attention promptly for symptoms such as severe headache, blurred vision, '
        'heavy bleeding, severe abdominal pain, high fever, or reduced fetal movement.',
    isWarning: true,
  ),
  _GuidanceTopic(
    title: 'Medication Awareness',
    icon: Icons.medication_outlined,
    content:
        'Only take medication prescribed or approved by a qualified healthcare provider during pregnancy. '
        'Always mention all current medications and supplements during ANC visits.',
  ),
  _GuidanceTopic(
    title: 'Rest & Sleep',
    icon: Icons.bedtime_outlined,
    content:
        'Aim for adequate rest, including short daytime naps if needed. '
        'Sleeping on the side, particularly the left side, is generally recommended in later pregnancy.',
  ),
];

class HealthGuidanceScreen extends StatelessWidget {
  const HealthGuidanceScreen({super.key});

  void _showDetail(BuildContext context, _GuidanceTopic topic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: topic.isWarning
                    ? AppColors.danger.withValues(alpha: 0.12)
                    : AppColors.lightPink,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                topic.icon,
                color: topic.isWarning ? AppColors.danger : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(topic.title)),
          ],
        ),
        content: Text(topic.content, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Guidance')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maternal health information',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppMetrics.spaceL),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppMetrics.spaceM,
                  crossAxisSpacing: AppMetrics.spaceM,
                  childAspectRatio: 1.0,
                ),
                itemCount: _topics.length,
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  return Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                    child: InkWell(
                      onTap: () => _showDetail(context, topic),
                      borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                      child: Container(
                        padding: const EdgeInsets.all(AppMetrics.spaceM),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                          border: topic.isWarning
                              ? Border.all(color: AppColors.danger.withValues(alpha: 0.3))
                              : null,
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: topic.isWarning
                                    ? AppColors.danger.withValues(alpha: 0.10)
                                    : AppColors.lightPink,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                topic.icon,
                                color: topic.isWarning ? AppColors.danger : AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            Text(topic.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to read more',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 3,
        onTap: (index) => handleTabTap(context, index, 3),
      ),
    );
  }
}
