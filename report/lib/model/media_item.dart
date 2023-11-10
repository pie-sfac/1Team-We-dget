class MediaItem {
  String uuid;
  String type;
  String url;
  String thumbnailUrl;

  MediaItem({required this.uuid, required this.type, required this.url, required this.thumbnailUrl});

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      uuid: map['uuid'],
      type: map['type'],
      url: map['url'],
      thumbnailUrl: map['thumbnailUrl'],
    );
  }
}