class ProfileModel {
  final String id;
  final String username;
  final String stageName;
  final String bio;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int profileViews;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.stageName,
    required this.bio,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.profileViews = 0,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, String fallbackUsername) {
    return ProfileModel(
      id: map['id'] ?? '',
      username: map['username'] ?? fallbackUsername,
      stageName: map['stage_name'] ?? 'New Creator',
      bio: map['bio'] ?? 'Afrobeat artist • Creative storyteller',
      avatarUrl: map['avatar_url'],
      followersCount: map['followers_count'] ?? 0,
      followingCount: map['following_count'] ?? 0,
      postsCount: map['posts_count'] ?? 0,
      profileViews: map['profile_views'] ?? 0,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? username,
    String? stageName,
    String? bio,
    String? avatarUrl,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? profileViews,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      stageName: stageName ?? this.stageName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      profileViews: profileViews ?? this.profileViews,
    );
  }
}
