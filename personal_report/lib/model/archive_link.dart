import 'package:personal_report/model/archive_item.dart';

class ArchiveLink {
  bool hidden;
  List<ArchiveItem> items;

  ArchiveLink({required this.hidden, required this.items});

  factory ArchiveLink.fromMap(Map<String, dynamic> map) {
    List<ArchiveItem> archiveItems = List<ArchiveItem>.from(map['items'].map((e) => ArchiveItem.fromMap(e)));

    return ArchiveLink(
      hidden: map['hidden'],
      items: archiveItems,
    );
  }
}
