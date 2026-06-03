import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_settings_sheet.dart';
import '../widgets/profile/profile_edit_sheet.dart';
import '../widgets/profile/profile_tabs_sections.dart';

class ArtistProfileScreen extends StatefulWidget {
  final ProfileModel? fallbackProfile;

  const ArtistProfileScreen({
    super.key,
    this.fallbackProfile,
  });

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
    _controller.syncProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ProfileModel _getDefaultFallback() {
    return const ProfileModel(
      id: '',
      username: 'user_fallback',
      stageName: 'New Creator',
      bio: 'Afrobeat artist • Producer • Creative storyteller',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<ProfileState>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? _controller.state;
        final activeProfile = state.profile ?? widget.fallbackProfile ?? _getDefaultFallback();

        return Scaffold(
          backgroundColor: colors.surface,
          body: RefreshIndicator(
            onRefresh: _controller.syncProfile,
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
                    expandedHeight: 520,
                    title: innerBoxIsScrolled 
                        ? Text('@${activeProfile.username}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)) 
                        : null,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const ProfileSettingsSheet(),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SafeArea(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              ProfileHeader(profile: activeProfile),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton.icon(
                                        icon: const Icon(Icons.edit_outlined, size: 18),
                                        label: const Text('Modify Profile States', style: TextStyle(fontWeight: FontWeight.bold)),
                                        style: FilledButton.styleFrom(
                                          minimumSize: const Size(double.infinity, 48),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: Container(
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.2)))),
                        child: TabBar(
                          controller: _tabController,
                          dividerColor: Colors.transparent,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          tabs: const [
                            Tab(text: 'Timeline'),
                            Tab(text: 'Music'),
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
