class ExerciseSet {
  int setNum;
  num weight;
  int repeat;
  int? time;
  int? distance;

  ExerciseSet({required this.setNum, required this.weight, required this.repeat, this.time, this.distance});

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      setNum: map['setNum'],
      weight: map['weight'],
      repeat: map['repeat'],
      time: map['time'],
      distance: map['distance'],
    );
  }
}