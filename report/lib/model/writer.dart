class Writer {
  int id;
  String name;

  Writer({required this.id, required this.name});

  factory Writer.fromMap(Map<String, dynamic> map) {
    return Writer(
      id: map['id'],
      name: map['name'],
    );
  }
}