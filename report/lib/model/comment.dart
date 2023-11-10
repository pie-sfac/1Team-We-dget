class Comment {
  bool hidden;
  String content;

  Comment({required this.hidden, required this.content});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      hidden: map['hidden'],
      content: map['content'],
    );
  }
}