import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_action_buttons.dart';
import '../widgets/profile/profile_tabs_sections.dart';
import '../widgets/profile/profile_settings_sheet.dart';
import '../widgets/profile/profile_edit_sheet.dart';
import '../widgets/profile/profile_skeleton.dart';

class ArtistProfileScreen extends StatefulWidget {
  const ArtistProfileScreen({super.key});

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _controller = ProfileController.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controller.syncProfileData();
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const ProfileSettingsSheet(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading && _controller.currentProfile == null) {
          return Scaffold(
            backgroundColor: colors.surface,
            body: const SafeArea(child: ProfileSkeleton()),
          );
        }

        final profile = _controller.currentProfile;

        return Scaffold(
          backgroundColor: colors.surface,
          body: RefreshIndicator(
            onRefresh: _controller.syncProfileData,
            child: NestedScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: colors.surface,
                    surfaceTintColor: Colors.transparent,
                    expandedHeight: 440,
                    title: innerBoxIsScrolled && profile != null
                        ? Text('@${profile.username}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)) 
                        : null,
                    actions: [
                      if (_controller.pendingSyncCount > 0)
                        IconButton(
                          icon: const Icon(Icons.sync_problem_rounded, color: Colors.amber),
                          onPressed: () async {
                            await _controller.flushPendingSyncs();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Attempting background synchronization sync...')),
                            );
                          },
                        ),
                      IconButton(
                        icon: Icon(Icons.settings_outlined, color: colors.onSurface),
                        onPressed: _showSettingsBottomSheet,
                      ),
                      const SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: SafeArea(
                        child: Column(
                          children: [
                            if (profile != null) ProfileHeader(profile: profile),
                            const SizedBox(height: 20),
                            if (profile != null) ProfileStats(profile: profile),
                            const SizedBox(height: 22),
                            ProfileActionButtons(
                              onEditPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => const ProfileEditSheet(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(58),
                      child: Container(
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.25)))),
                        child: TabBar(
                          controller: _tabController,
                          dividerColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          indicatorWeight: 2.5,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(icon: Icon(Icons.dynamic_feed_rounded), text: 'Timeline'),
                            Tab(icon: Icon(Icons.library_music_rounded), text: 'Music'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: const [
                  SingleChildScrollView(physics: BouncingScrollPhysics(), child: ProfileTimelineSection()),
                  SingleChildScrollView(physics: BouncingScrollPhysics(), child: ProfileMusicSection()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}