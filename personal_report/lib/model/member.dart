class Member {
  int id;
  String name;
  String phone;
  String sex;

  Member({required this.id, required this.name, required this.phone, required this.sex});

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      sex: map['sex'],
    );
  }
}
