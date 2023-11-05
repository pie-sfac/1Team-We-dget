class Center {
  int id;
  String name;
  String code;

  Center({required this.id, required this.name, required this.code});

  factory Center.fromMap(Map<String, dynamic> map) {
    return Center(
      id: map['id'],
      name: map['name'],
      code: map['code'],
    );
  }
}