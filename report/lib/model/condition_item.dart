class ConditionItem {
  String date;
  String condition;

  ConditionItem({required this.date, required this.condition});

  factory ConditionItem.fromMap(Map<String, dynamic> map) {
    return ConditionItem(
      date: map['date'],
      condition: map['condition'],
    );
  }
}