import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = DummyData.reportSummary;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Summary')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: AppMetrics.spaceM,
                crossAxisSpacing: AppMetrics.spaceM,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    label: 'Total Patients',
                    value: '${summary['Total Patients']}',
                    icon: Icons.people_alt_rounded,
                    color: AppColors.primary,
                  ),
                  _StatCard(
                    label: 'ANC Visits',
                    value: '${summary['ANC Visits']}',
                    icon: Icons.medical_services_rounded,
                    color: AppColors.secondary,
                  ),
                  _StatCard(
                    label: 'Low Risk',
                    value: '${summary['Low Risk']}',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                  _StatCard(
                    label: 'Medium Risk',
                    value: '${summary['Medium Risk']}',
                    icon: Icons.warning_rounded,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.spaceM),
              _StatCard(
                label: 'High Risk',
                value: '${summary['High Risk']}',
                icon: Icons.dangerous_rounded,
                color: AppColors.danger,
                wide: true,
              ),

              const SizedBox(height: AppMetrics.spaceXL),
              const SectionHeader(title: 'Risk Distribution', icon: Icons.pie_chart_outline_rounded),
              _RiskDistributionChart(summary: summary),

              const SizedBox(height: AppMetrics.spaceXL),
              const SectionHeader(title: 'ANC Visits Overview', icon: Icons.bar_chart_rounded),
              _AncVisitsChart(),

              const SizedBox(height: AppMetrics.spaceXL),
              const SectionHeader(title: 'Patient Overview', icon: Icons.insights_rounded),
              _PatientOverviewCard(summary: summary),
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool wide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : null,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(label, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskDistributionChart extends StatelessWidget {
  final Map<String, int> summary;
  const _RiskDistributionChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    final low = summary['Low Risk'] ?? 0;
    final medium = summary['Medium Risk'] ?? 0;
    final high = summary['High Risk'] ?? 0;
    final total = (low + medium + high).clamp(1, 1 << 30);

    return Container(
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  Expanded(flex: low, child: Container(color: AppColors.success)),
                  Expanded(flex: medium, child: Container(color: AppColors.warning)),
                  Expanded(flex: high, child: Container(color: AppColors.danger)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppMetrics.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legend('Low', low, total, AppColors.success),
              _legend('Medium', medium, total, AppColors.warning),
              _legend('High', high, total, AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, int count, int total, Color color) {
    final pct = ((count / total) * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
          ],
        ),
        const SizedBox(height: 2),
        Text('$count ($pct%)', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}

class _AncVisitsChart extends StatelessWidget {
  // Static dummy monthly data purely for UI visualization.
  static const _months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
  static const _visits = [8, 11, 14, 12, 16, 15];

  @override
  Widget build(BuildContext context) {
    final maxVal = _visits.reduce((a, b) => a > b ? a : b);
    return Container(
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
      child: SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_months.length, (i) {
            final heightFactor = _visits[i] / maxVal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${_visits[i]}', style: const TextStyle(fontSize: 11, color: AppColors.greyText)),
                const SizedBox(height: 4),
                Container(
                  width: 22,
                  height: 100 * heightFactor,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(_months[i], style: const TextStyle(fontSize: 12, color: AppColors.darkText)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _PatientOverviewCard extends StatelessWidget {
  final Map<String, int> summary;
  const _PatientOverviewCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final total = summary['Total Patients'] ?? 0;
    final visits = summary['ANC Visits'] ?? 0;
    final avg = total > 0 ? (visits / total).toStringAsFixed(1) : '0';

    return Container(
      padding: const EdgeInsets.all(AppMetrics.spaceM),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_2_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'On average, each patient has attended $avg ANC visits this quarter.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
