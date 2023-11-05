import 'package:personal_report/model/exercise_set.dart';

class ExerciseItem {
  String exerciseName;
  int orderNum;
  String memo;
  String createdAt;
  List<ExerciseSet> sets;

  ExerciseItem({required this.exerciseName, required this.orderNum, required this.memo, required this.createdAt, required this.sets});

  factory ExerciseItem.fromMap(Map<String, dynamic> map) {
    List<ExerciseSet> exerciseSets = List<ExerciseSet>.from(map['sets'].map((e) => ExerciseSet.fromMap(e)));

    return ExerciseItem(
      exerciseName: map['exerciseName'],
      orderNum: map['orderNum'],
      memo: map['memo'],
      createdAt: map['createdAt'],
      sets: exerciseSets,
    );
  }
}