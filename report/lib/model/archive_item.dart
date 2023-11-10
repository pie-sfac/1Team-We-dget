class ArchiveItem {
  String url;
  String title;
  String description;

  ArchiveItem({required this.url, required this.title, required this.description});

  factory ArchiveItem.fromMap(Map<String, dynamic> map) {
    return ArchiveItem(
      url: map['url'],
      title: map['title'],
      description: map['description'],
    );
  }
}