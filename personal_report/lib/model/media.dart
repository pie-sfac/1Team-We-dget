import 'package:personal_report/model/media_item.dart';

class Media {
  bool hidden;
  List<MediaItem> items;

  Media({required this.hidden, required this.items});

  factory Media.fromMap(Map<String, dynamic> map) {
    List<MediaItem> mediaItems = List<MediaItem>.from(map['items'].map((e) => MediaItem.fromMap(e)));

    return Media(
      hidden: map['hidden'],
      items: mediaItems,
    );
  }
}