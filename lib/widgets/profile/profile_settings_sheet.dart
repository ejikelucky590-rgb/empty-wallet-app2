import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';

class ProfileSettingsSheet extends StatelessWidget {
  const ProfileSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = ProfileController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isOffline = controller.network == NetworkState.offline;

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Drag Pill
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Account Settings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              /// SIMULATED NETWORK TOGGLE (INSTAGRAM DEV MODE STYLE)
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.15)),
                ),
                child: SwitchListTile.adaptive(
                  title: const Text(
                    'Simulate Offline Mode',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  subtitle: Text(
                    isOffline 
                        ? 'Queueing profile changes locally to disk' 
                        : 'Connected directly to live Supabase backend',
                    style: TextStyle(color: colors.outline, fontSize: 12),
                  ),
                  secondary: Icon(
                    isOffline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                    color: isOffline ? Colors.amber : colors.primary,
                  ),
                  value: isOffline,
                  onChanged: (val) {
                    controller.setNetwork(val ? NetworkState.offline : NetworkState.online);
                  },
                ),
              ),
              const SizedBox(height: 12),

              /// QUEUE COUNTER INDICATOR
              ListTile(
                leading: Icon(Icons.dns_rounded, color: colors.outline),
                title: const Text('Pending Sync Backlog', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.pending > 0 ? Colors.amber.withValues(alpha: 0.2) : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${controller.pending} payloads',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: controller.pending > 0 ? Colors.amber[900] : colors.outline,
                    ),
                  ),
                ),
                onTap: controller.pending > 0 ? () => controller.syncProfile() : null,
              ),
              
              Divider(color: colors.outlineVariant.withValues(alpha: 0.15), height: 24),

              /// DESTRUCTIVE LOG OUT ACTION
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text(
                  'Sign Out Account',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Auth signout hook can drop here later smoothly
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
