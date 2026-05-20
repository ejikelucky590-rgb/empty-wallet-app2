import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/profile_header.dart';
import 'widgets/media_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final _supabase = Supabase.instance.client;
  final ScrollController _videoScrollController = ScrollController();
  final ScrollController _musicScrollController = ScrollController();

  bool _isLoading = true;
  bool _isPaginatingVideos = false;
  bool _isPaginatingMusic = false;
  bool _hasMoreVideos = true;
  bool _hasMoreMusic = true;
  bool _isFollowing = false;
  final bool _isVerified = true;

  String _username = "@ejikelucky590";
  String _displayName = "Lucky Ejike";
  String _bio = "Building Dove Music 🕊️ | Software Developer based in Lagos 🇳🇬";
  String _profilePic = "https://images.unsplash.com/photo-1534528741775-53994a69daeb";

  int _followers = 12500;
  int _following = 348;
  int _likesCount = 89200;

  final List<Map<String, dynamic>> _videoPosts = [];
  final List<Map<String, dynamic>> _musicPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _videoScrollController.addListener(_videoPaginationListener);
    _musicScrollController.addListener(_musicPaginationListener);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoScrollController.dispose();
    _musicScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    _videoPosts.clear();
    _musicPosts.clear();

    for (int i = 0; i < 12; i++) {
      _videoPosts.add({
        "thumbnail": "https://picsum.photos/400/700?random=$i",
        "views": "${(4.2 + i).toStringAsFixed(1)}K",
      });
      _musicPosts.add({
        "thumbnail": "https://picsum.photos/400/700?random=${i + 50}",
        "views": "${(2.1 + i).toStringAsFixed(1)}K",
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProfile() async {
    await _loadProfile();
  }

  Future<void> _loadMoreVideos() async {
    if (_isPaginatingVideos || !_hasMoreVideos) return;
    setState(() => _isPaginatingVideos = true);
    await Future.delayed(const Duration(seconds: 2));
    final start = _videoPosts.length;

    for (int i = start; i < start + 9; i++) {
      _videoPosts.add({
        "thumbnail": "https://picsum.photos/400/700?random=${i + 100}",
        "views": "${(4.2 + i).toStringAsFixed(1)}K",
      });
    }
    if (_videoPosts.length > 45) _hasMoreVideos = false;
    if (mounted) setState(() => _isPaginatingVideos = false);
  }

  Future<void> _loadMoreMusic() async {
    if (_isPaginatingMusic || !_hasMoreMusic) return;
    setState(() => _isPaginatingMusic = true);
    await Future.delayed(const Duration(seconds: 2));
    final start = _musicPosts.length;

    for (int i = start; i < start + 9; i++) {
      _musicPosts.add({
        "thumbnail": "https://picsum.photos/400/700?random=${i + 200}",
        "views": "${(1.8 + i).toStringAsFixed(1)}K",
      });
    }
    if (_musicPosts.length > 45) _hasMoreMusic = false;
    if (mounted) setState(() => _isPaginatingMusic = false);
  }

  void _videoPaginationListener() {
    if (_videoScrollController.position.pixels >=
        _videoScrollController.position.maxScrollExtent - 500) {
      _loadMoreVideos();
    }
  }

  void _musicPaginationListener() {
    if (_musicScrollController.position.pixels >=
        _musicScrollController.position.maxScrollExtent - 500) {
      _loadMoreMusic();
    }
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      _followers = _isFollowing ? _followers + 1 : _followers - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_displayName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            if (_isVerified) ...[
              const SizedBox(width: 6),
              Icon(Icons.verified, color: theme.colorScheme.primary, size: 20),
            ],
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: theme.colorScheme.primary,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: _isLoading
                    ? _buildProfileSkeleton(context)
                    : ProfileHeader(
                        username: _username,
                        displayName: _displayName,
                        bio: _bio,
                        profilePic: _profilePic,
                        following: _following,
                        followers: _followers,
                        likesCount: _likesCount,
                        isFollowing: _isFollowing,
                        isVerified: _isVerified,
                        onToggleFollow: _toggleFollow,
                      ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: theme.disabledColor,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on_rounded)),
                      Tab(icon: Icon(Icons.music_note_rounded)),
                    ],
                  ),
                  theme.scaffoldBackgroundColor,
                ),
              ),
            ];
          },
          body: _isLoading
              ? const SizedBox()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    MediaGrid(
                      posts: _videoPosts,
                      controller: _videoScrollController,
                      isVideo: true,
                      isPaginating: _isPaginatingVideos,
                    ),
                    MediaGrid(
                      posts: _musicPosts,
                      controller: _musicScrollController,
                      isVideo: false,
                      isPaginating: _isPaginatingMusic,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.cardColor,
      highlightColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(radius: 50),
          const SizedBox(height: 16),
          Container(width: 120, height: 16, color: Colors.white),
          const SizedBox(height: 12),
          Container(width: 180, height: 14, color: Colors.white),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(width: 50, height: 16, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 40, height: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.backgroundColor);

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
