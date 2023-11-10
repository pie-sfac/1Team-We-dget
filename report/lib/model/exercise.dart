import 'package:report/model/exercise_item.dart';

class Exercise {
  bool hidden;
  List<ExerciseItem> items;

  Exercise({required this.hidden, required this.items});

  factory Exercise.fromMap(Map<String, dynamic> map) {
    List<ExerciseItem> exerciseItems = List<ExerciseItem>.from(map['items'].map((item) => ExerciseItem.fromMap(item)));

    return Exercise(
      hidden: map['hidden'],
      items: exerciseItems,
    );
  }
}