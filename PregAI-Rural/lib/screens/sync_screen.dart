import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isSyncing = false;
  bool _isOnline = true;
  int _pendingRecords = 8;
  String _lastSync = '12 Aug 2026, 4:30 PM';

  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    // Simulated progress only — no real synchronization occurs.
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _pendingRecords = 0;
      _lastSync = 'Just now';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.cloud_done_rounded, color: AppColors.success),
            SizedBox(width: 12),
            Text('Sync completed successfully'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Synchronization')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppMetrics.spaceL),
                decoration: BoxDecoration(
                  color: _isOnline
                      ? AppColors.success.withValues(alpha: 0.10)
                      : AppColors.greyText.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                  border: Border.all(
                    color: _isOnline
                        ? AppColors.success.withValues(alpha: 0.35)
                        : AppColors.greyText.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                      color: _isOnline ? AppColors.success : AppColors.greyText,
                      size: 32,
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Status', style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          _isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _isOnline ? AppColors.success : AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      value: _isOnline,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) => setState(() => _isOnline = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              Container(
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lightPink,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.history_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Sync', style: Theme.of(context).textTheme.bodyMedium),
                        Text(_lastSync, style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceM),
              Container(
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _pendingRecords > 0
                            ? AppColors.warning.withValues(alpha: 0.12)
                            : AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: _pendingRecords > 0 ? AppColors.warning : AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Expanded(
                      child: Text(
                        'Records waiting for synchronization: $_pendingRecords',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceXL),
              if (_isSyncing) ...[
                const LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.lightPink,
                ),
                const SizedBox(height: AppMetrics.spaceM),
              ],
              AppButton(
                label: 'Sync Now',
                icon: Icons.sync_rounded,
                isLoading: _isSyncing,
                onPressed: _pendingRecords > 0 ? _syncNow : null,
              ),
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
    );
  }
}
