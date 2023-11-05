import 'package:personal_report/model/pain_history_item.dart';

class PainHistory {
  bool hidden;
  List<PainHistoryItem> items;

  PainHistory({required this.hidden, required this.items});

  factory PainHistory.fromMap(Map<String, dynamic> map) {
    List<PainHistoryItem> painHistoryItems = List<PainHistoryItem>.from(map['items'].map((e) => PainHistoryItem.fromMap(e)));

    return PainHistory(
      hidden: map['hidden'],
      items: painHistoryItems,
    );
  }
}