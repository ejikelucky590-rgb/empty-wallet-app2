import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_settings_sheet.dart';
import '../widgets/profile/profile_edit_sheet.dart';

class ArtistProfileScreen extends StatefulWidget {
  final ProfileModel fallbackProfile;

  const ArtistProfileScreen({
    super.key,
    required this.fallbackProfile,
  });

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  final _controller = ProfileController.instance;

  @override
  void initState() {
    super.initState();
    _controller.syncProfile();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final activeProfile = _controller.profile ?? widget.fallbackProfile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Creator Profile', style: TextStyle(fontWeight: FontWeight.w800)),
            actions: [
              if (_controller.pending > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text('${_controller.pending} pending'),
                    backgroundColor: Colors.amber.withValues(alpha: 0.2),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const ProfileSettingsSheet(),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _controller.syncProfile,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                ProfileHeader(profile: activeProfile),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modify Profile States'),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const ProfileEditSheet(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
