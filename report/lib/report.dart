// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:report/model/exercise.dart';
import 'package:report/model/exercise_item.dart';
import 'package:report/model/exercise_set.dart';
import 'package:report/model/person.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isExpanded = false;
  Dio dio = Dio();
  Person? person;

  Future<Person?> fetchData() async {
    var url = "https://flutterapi.tykan.me/personal-reports/";
    var uuid = "4d61d864-4885-4fff-a2f5-07f9b599885d";
    var res = await dio.get(url + uuid);

    if(res.statusCode == 200) {
      person = Person.fromMap(res.data);
      print(res.data['member']['name']);
      print(person!.member.name);
      return person;
    }
    return null;
  }

  @override  // 로딩 화면 구현하여 대체.
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
            person == null
            ? CircularProgressIndicator(color: Colors.amber)
            : Text('${person!.member.name} 회원님'),  // person.member.name
          centerTitle: false,
          backgroundColor: const Color.fromARGB(0, 17, 17, 17),
          foregroundColor: Colors.black,
          actions: [
            Row(
              children: [
                Row(
                  children:[
                    Text('과거 레포트 보러가기'),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(Icons.navigate_next),
                    ),  // 페이지 이동.
                  ]
                )
              ]
            )  
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListView(
            children: [
              person == null
              ? CircularProgressIndicator(color: Colors.amber)
              : renderTitle('${person!.member.name} 회원님 영상 및 이미지'),
              Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.media.items.length ?? 0,
                          itemBuilder: (context, index) {
                            final mediaItem = snapshot.data!.media.items[index];
                            final isVideo = mediaItem.type == 'VIDEO';

                            return GestureDetector(
                              onTap: () {
                                // Handle video play action for videos
                                if (isVideo) {
                                  // Play video
                                }
                              },
                              child: Card(
                                elevation: 0,
                                // width: 100,
                                // height: 100,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(  // Card로 변경
                                        width: 100,
                                        height: MediaQuery.of(context).size.height,
                                        child: CachedNetworkImage(
                                          imageUrl: mediaItem.thumbnailUrl,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                    ),
                                    if (isVideo)
                                      Container(  // Card로 변경
                                        width: 100,
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.play_circle_outlined,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ] 
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return LinearProgressIndicator();
                    },
                  ),
                ),
              person == null
              ? CircularProgressIndicator(color: Colors.amber)
              : renderTitle('${person!.writer.name} 선생님 피드백'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        person!.comment.content,
                        // overflow: TextOverflow.ellipsis,
                        overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        ),
                    ),
                    Divider(
                      thickness: 2,
                      ),
                    // Icon(CupertinoIcons.chevron_down),
                    IconButton(
                      icon: Icon(
                        isExpanded
                            ? CupertinoIcons.chevron_up
                            : CupertinoIcons.chevron_down,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ),
              ),
              person == null
              ? CircularProgressIndicator(color: Colors.amber)
              : renderTitle('센터 추천 링크'),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data != null) {
                      return GridView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.3,
                        ),
                        itemCount: person!.archiveLink.items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey)
                            ),
                            // padding: EdgeInsets.all(8),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(16),
                            //   border: Border.all(color: Colors.grey),
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://img.youtube.com/vi/${_extractVideoId(snapshot.data!.archiveLink.items[index].url)}/default.jpg',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.archiveLink.items[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return LinearProgressIndicator();
                  }
                ),
              ),
              renderTitle('통증 변화'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    person == null
                    ? CircularProgressIndicator(color: Colors.amber)
                    : Text('${person!.member.name} 회원님의 통증 변화 그래프입니다.'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Placeholder(),
                    ),
                  ],
                ),
              ),
              renderTitle('컨디션 변화'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: 
                person == null
                ? CircularProgressIndicator(color: Colors.amber)
                : Text('${person!.member.name} 회원님의 컨디션 변화입니다.'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData && snapshot.data != null) {
                          return Container(
                            // width: 100,
                            height: 100,
                            child: Center(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  String translateCondition(String condition) {
                                    Map<String, String> conditionMap = {
                                      'VERY_GOOD': '매우 좋음',
                                      'GOOD': '좋음',
                                      'NORMAL': '보통',
                                      'BAD': '나쁨',
                                      'VERY_BAD': '매우 나쁨',
                                    };
                                    return conditionMap[condition] ?? 'Unknown Condition';
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage('assets/${person!.condition.items[index].condition}.png'),
                                          radius: 20,
                                        ),
                                        Text(translateCondition(person!.condition.items[index].condition)),
                                        Text(DateFormat('yy.MM.dd').format(DateTime.parse(person!.condition.items[index].date))),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      return LinearProgressIndicator();
                      }
                    ),
                  ],
                ),
              ),
              renderTitle('운동 기록'),
              Container(
                child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final Exercise exercise = snapshot.data!.exercise;
                      final List<ExerciseItem> exercises = exercise.items;
                      String selectedExerciseName = exercises.first.exerciseName;
                      List<ExerciseSet> sets = exercises
                          .firstWhere((exerciseItem) => exerciseItem.exerciseName == selectedExerciseName)
                          .sets;
                      bool showAllRows = false;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${snapshot.data!.member.name} 회원님의 운동 기록입니다.'),
                                  DropdownButton<String>(
                                    value: selectedExerciseName,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedExerciseName = value!;
                                        sets = exercises
                                        .firstWhere((exerciseItem) => exerciseItem.exerciseName == selectedExerciseName)
                                        .sets;
                                      });
                                    },
                                    items: exercises.map((exerciseItem) => DropdownMenuItem(
                                      child: Text(exerciseItem.exerciseName),
                                      value: exerciseItem.exerciseName,
                                    )).toList(),
                                  ),
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('세트')),
                                      DataColumn(label: Text('무게')),
                                      DataColumn(label: Text('횟수')),
                                      DataColumn(label: Text('시간')),
                                      DataColumn(label: Text('거리')),
                                    ],
                                    rows: showAllRows
                                      ? sets.map((set) => DataRow(
                                          cells: [
                                            DataCell(Text('${set.setNum}')),
                                            set.weight == null
                                            ? DataCell(Text('-'))
                                            : DataCell(Text('${set.weight}kg')),
                                            set.repeat == null
                                            ? DataCell(Text('-'))
                                            : DataCell(Text('${set.repeat}회')),
                                            set.time == null
                                            ? DataCell(Text('-'))
                                            : DataCell(Text('${set.time}')),
                                            set.distance == null
                                            ? DataCell(Text('-'))
                                            : DataCell(Text('${set.distance}')),
                                          ],
                                        )).toList()
                                      : sets
                                        .take(4)
                                        .map((set) => DataRow(
                                              cells: [
                                                DataCell(Text('${set.setNum}')),
                                                set.weight == null ? DataCell(Text('-')) : DataCell(Text('${set.weight}kg')),
                                                set.repeat == null ? DataCell(Text('-')) : DataCell(Text('${set.repeat}회')),
                                                set.time == null ? DataCell(Text('-')) : DataCell(Text('${set.time}')),
                                                set.distance == null ? DataCell(Text('-')) : DataCell(Text('${set.distance}')),
                                              ],
                                            ))
                                        .toList(), 
                                  ),
                                  Center(
                                    child: IconButton(
                                      icon: Icon(
                                        showAllRows
                                            ? CupertinoIcons.chevron_up
                                            : CupertinoIcons.chevron_down,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showAllRows = !showAllRows;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    }
                    return LinearProgressIndicator();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    person == null
                    ? CircularProgressIndicator(color: Colors.amber)
                    : Text('${person!.member.name} 회원님의\n퍼스널 레포트를 공유해 보세요.'),
                    Text('내가 작성한 만족도와 함께 전달됩니다.'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(3, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(),
                              Text('링크복사'),
                            ],
                          ),
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(CupertinoIcons.building_2_fill),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('포인티센터'),
                        Text('서울시 남부순환로 1801, 라피스 빌딩 8층'),
                        Text('02-840-9002'),
                        Row(
                          children: [
                            Text('카카오톡 문의 :'),
                            TextButton(
                              onPressed: () {},
                              child: Text('포인티 센터 바로가기'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
                  ),
          ),
        ),
      ),
    );
  }
  renderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16,
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
          ),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
    );
  }
  String _extractVideoId(String youtubeUrl) {
    final parts = youtubeUrl.split('/');
    if (parts.isNotEmpty) {
      return parts.last; // The last part of the URL is the video ID
    }
    return ""; // Handle cases where the URL doesn't match the expected format
  }
}

