class Track {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final String artworkUrl;
  final Duration? duration;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.artworkUrl,
    this.duration,
  });
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}
