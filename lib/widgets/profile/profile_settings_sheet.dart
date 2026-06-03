import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';

class ProfileSettingsSheet extends StatelessWidget {
  const ProfileSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final controller = ProfileController.instance;

    return StreamBuilder<ProfileState>(
      stream: controller.stream,
      initialData: controller.state,
      builder: (context, snapshot) {
        final state = snapshot.data!;
        final isOffline = state.network == NetworkState.offline;

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Settings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              
              /// SYNC STATUS CARD
              InkWell(
                onTap: state.pending > 0 ? () => controller.syncProfile() : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: state.pending > 0 ? Colors.amber.withValues(alpha: 0.2) : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.pending} payloads waiting to sync',
                        style: TextStyle(
                          color: state.pending > 0 ? Colors.amber[900] : colors.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (state.pending > 0) const Icon(Icons.refresh, color: Colors.amber),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Network Mode'),
                trailing: Text(isOffline ? 'Offline' : 'Online'),
                leading: Icon(isOffline ? Icons.cloud_off : Icons.cloud_done),
              ),
            ],
          ),
        );
      },
    );
  }
}
