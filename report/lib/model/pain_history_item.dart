class PainHistoryItem {
  String date;
  int level;

  PainHistoryItem({required this.date, required this.level});

  factory PainHistoryItem.fromMap(Map<String, dynamic> map) {
    return PainHistoryItem(
      date: map['date'],
      level: map['level'],
    );
  }
}
