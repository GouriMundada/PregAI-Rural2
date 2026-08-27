import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/patient_card.dart';
import 'patient_details_screen.dart';

class PatientRecordsScreen extends StatefulWidget {
  final RiskLevel? initialFilter;

  const PatientRecordsScreen({super.key, this.initialFilter});

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  String _query = '';
  RiskLevel? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  List<Patient> get _filtered {
    return DummyData.patients.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == null || p.riskLevel == _filter;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppMetrics.spaceL),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by risk status', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppMetrics.spaceM),
            _filterTile('All Patients', null),
            _filterTile('Low Risk', RiskLevel.low),
            _filterTile('Medium Risk', RiskLevel.medium),
            _filterTile('High Risk', RiskLevel.high),
          ],
        ),
      ),
    );
  }

  Widget _filterTile(String label, RiskLevel? level) {
    final selected = _filter == level;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: selected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () {
        setState(() => _filter = level);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Records')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.spaceL,
                AppMetrics.spaceM,
                AppMetrics.spaceL,
                AppMetrics.spaceM,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => _query = value),
                      decoration: const InputDecoration(
                        hintText: 'Search patient...',
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceS),
                  Material(
                    color: _filter != null ? AppColors.primary : AppColors.lightPink,
                    borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
                    child: InkWell(
                      onTap: _openFilterSheet,
                      borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: _filter != null ? AppColors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? _EmptyState(query: _query)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppMetrics.spaceL,
                        0,
                        AppMetrics.spaceL,
                        AppMetrics.spaceL,
                      ),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppMetrics.spaceM),
                      itemBuilder: (context, index) {
                        final patient = results[index];
                        return PatientCard(
                          patient: patient,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PatientDetailsScreen(patient: patient),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: (index) => handleTabTap(context, index, 1),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.lightPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.folder_off_outlined, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: AppMetrics.spaceM),
            Text(
              query.isEmpty ? 'No patient records yet' : 'No patients match "$query"',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Registered patients will appear here.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
