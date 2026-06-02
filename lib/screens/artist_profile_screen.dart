import 'package:flutter/material.dart';
import '../widgets/profile/profile_tabs_sections.dart';

class ArtistProfileScreen extends StatefulWidget {
  const ArtistProfileScreen({super.key});

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: colors.surface,
              surfaceTintColor: Colors.transparent,
              expandedHeight: 440,
              title: innerBoxIsScrolled
                  ? const Text(
                      '@dove_creator',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    )
                  : null,
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.settings_outlined, color: colors.onSurface),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onSelected: (value) {
                    String message = '';
                    if (value == 'edit_profile') message = 'Edit profile screen coming soon.';
                    else if (value == 'theme') message = 'Appearance settings coming soon.';
                    else if (value == 'notifications') message = 'Notification settings coming soon.';
                    else if (value == 'privacy') message = 'Privacy settings coming soon.';
                    else if (value == 'security') message = 'Security settings coming soon.';
                    else if (value == 'logout') {
                      Navigator.of(context).pushReplacementNamed('/login');
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'edit_profile',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20, color: colors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'theme',
                      child: Row(
                        children: [
                          Icon(Icons.palette_outlined, size: 20, color: colors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'notifications',
                      child: Row(
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 20, color: colors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'privacy',
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 20, color: colors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          const Text('Privacy', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'security',
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 20, color: colors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          const Text('Security', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded, size: 20, color: Colors.redAccent),
                          const SizedBox(width: 12),
                          const Text('Logout', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.outlineVariant, width: 1),
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: colors.primaryContainer,
                            child: Icon(Icons.person, size: 46, color: colors.onPrimaryContainer),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Dove Artist',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@dove_creator',
                          style: TextStyle(color: colors.outline, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        // Presence Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Active now',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Text(
                            'Afrobeat artist • Producer • Creative storyteller',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _ProfileStatItem(value: '12.4K', label: 'Followers'),
                            _ProfileStatItem(value: '231', label: 'Following'),
                            _ProfileStatItem(value: '89', label: 'Posts'),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  elevation: 0,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('Message', style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.25)),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
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
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
      ],
    );
  }
}