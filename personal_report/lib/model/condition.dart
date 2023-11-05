import 'package:personal_report/model/condition_item.dart';

class Condition {
  bool hidden;
  List<ConditionItem> items;

  Condition({required this.hidden, required this.items});

  factory Condition.fromMap(Map<String, dynamic> map) {
    List<ConditionItem> conditionItems = List<ConditionItem>.from(map['items'].map((e) => ConditionItem.fromMap(e)));

    return Condition(
      hidden: map['hidden'],
      items: conditionItems,
    );
  }
}