class MusicModel {
  final String id;
  final String ownerId;
  final String title;
  final String artistName;
  final String audioUrl;
  final String? coverUrl;
  final String genre;
  final String description;
  final int durationSeconds;
  final int playCount;
  final int likeCount;
  final DateTime createdAt;

  const MusicModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.artistName,
    required this.audioUrl,
    this.coverUrl,
    required this.genre,
    required this.description,
    required this.durationSeconds,
    this.playCount = 0,
    this.likeCount = 0,
    required this.createdAt,
  });

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] ?? '',
      ownerId: map['owner_id'] ?? '',
      title: map['title'] ?? '',
      artistName: map['artist_name'] ?? '',
      audioUrl: map['audio_url'] ?? '',
      coverUrl: map['cover_url'],
      genre: map['genre'] ?? '',
      description: map['description'] ?? '',
      durationSeconds: map['duration_seconds'] ?? 0,
      playCount: map['play_count'] ?? 0,
      likeCount: map['like_count'] ?? 0,
      createdAt: DateTime.tryParse(
            map['created_at'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'artist_name': artistName,
      'audio_url': audioUrl,
      'cover_url': coverUrl,
      'genre': genre,
      'description': description,
      'duration_seconds': durationSeconds,
      'play_count': playCount,
      'like_count': likeCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MusicModel copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? artistName,
    String? audioUrl,
    String? coverUrl,
    String? genre,
    String? description,
    int? durationSeconds,
    int? playCount,
    int? likeCount,
    DateTime? createdAt,
  }) {
    return MusicModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      audioUrl: audioUrl ?? this.audioUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      playCount: playCount ?? this.playCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
