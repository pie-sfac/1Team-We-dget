// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:report/model/exercise.dart';
import 'package:report/model/exercise_item.dart';
import 'package:report/model/exercise_set.dart';
import 'package:report/model/pain_history.dart';
import 'package:report/model/pain_history_item.dart';
import 'package:report/model/person.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
      // print(res.data['member']['name']);
      // print(person!.member.name);
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
                                      clipBehavior: Clip.antiAlias,
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
                    FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final PainHistory painHistory = snapshot.data!.painHistory;
                          final List<PainHistoryItem> painHistoryItem = snapshot.data!.painHistory.items;
                          List<FlSpot> _generateSpots() {
                            return painHistoryItem.asMap().entries.map((entry) {
                              final index = entry.key;
                              final data = entry.value;
                              final date = DateTime.parse(data.date);
                              final level = data.level.toDouble();
                              return FlSpot(index.toDouble(), level);
                            }).toList();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1.7,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10),),),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true, 
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey,
                                            strokeWidth: 1
                                          );
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            reservedSize: 22,
                                            interval: 2,
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final painLevel = value;
                                              return FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text(painLevel.toString(), style: TextStyle(color: Colors.grey, fontSize: 0.5), textAlign: TextAlign.center),                                                
                                              );
                                            },
                                          )
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            interval: 1,
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final date = painHistory.items[value.toInt()].date;
                                              final formattedDate = DateFormat('yy.MM.dd').format(DateTime.parse(date));
                                              // final screenWidth = MediaQuery.of(context).size.width;
                                              // final fontSize = screenWidth * 0.001;
                                              return FittedBox(
                                                alignment: Alignment.center,
                                                fit: BoxFit.fitWidth,
                                                child: Text(formattedDate, style: TextStyle(color: Colors.grey, fontSize: 0.5), textAlign: TextAlign.center),
                                              );
                                            },
                                          )
                                        ),
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      minX: 0,
                                      maxX: painHistoryItem.length.toDouble()-1,
                                      minY: 0,
                                      maxY: painHistory.items.fold(0, (max, item) => item.level > max ? item.level : max).toDouble(),
                                      baselineY: -1,
                                      extraLinesData: const ExtraLinesData(),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _generateSpots(),
                                          isCurved: true,
                                          color: Colors.blue,
                                          dotData: FlDotData(show: true),
                                          belowBarData: BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return LinearProgressIndicator();
                      }
                    )
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
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: DataTable(
                                    // border: TableBorder(verticalInside: BorderSide.none, horizontalInside: BorderSide.none),
                                    // decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                    showBottomBorder: true,
                                    columnSpacing: 0.0,
                                    horizontalMargin: 0.0,
                                    columns: [
                                      DataColumn(label: Expanded(child: Text('세트', textAlign: TextAlign.center,)),),
                                      DataColumn(label: Expanded(child: Text('무게', textAlign: TextAlign.center,)),),
                                      DataColumn(label: Expanded(child: Text('횟수', textAlign: TextAlign.center,)),),
                                      DataColumn(label: Expanded(child: Text('시간', textAlign: TextAlign.center,)),),
                                      DataColumn(label: Expanded(child: Text('거리', textAlign: TextAlign.center,)),),
                                    ],
                                    rows: showAllRows
                                      ? sets.map((set) => DataRow(
                                          cells: [
                                            DataCell(Center(child: Text('${set.setNum}', textAlign: TextAlign.center,))),
                                            set.weight == null
                                            ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,)))
                                            : DataCell(Center(child: Text('${set.weight}kg', textAlign: TextAlign.center,))),
                                            set.repeat == null
                                            ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,)))
                                            : DataCell(Center(child: Text('${set.repeat}회', textAlign: TextAlign.center,))),
                                            set.time == null
                                            ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,)))
                                            : DataCell(Center(child: Text('${set.time}', textAlign: TextAlign.center,))),
                                            set.distance == null
                                            ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,)))
                                            : DataCell(Center(child: Text('${set.distance}', textAlign: TextAlign.center,))),
                                          ],
                                        )).toList()
                                      : sets
                                        .take(4)
                                        .map((set) => DataRow(
                                              cells: [
                                                DataCell(Center(child: Text('${set.setNum}', textAlign: TextAlign.center,))),
                                                set.weight == null 
                                                ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,))) 
                                                : DataCell(Center(child: Text('${set.weight}kg', textAlign: TextAlign.center,))),
                                                set.repeat == null 
                                                ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,))) 
                                                : DataCell(Center(child: Text('${set.repeat}회', textAlign: TextAlign.center,))),
                                                set.time == null 
                                                ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,))) 
                                                : DataCell(Center(child: Text('${set.time}', textAlign: TextAlign.center,))),
                                                set.distance == null 
                                                ? DataCell(Center(child: Text('-', textAlign: TextAlign.center,))) 
                                                : DataCell(Center(child: Text('${set.distance}', textAlign: TextAlign.center,))),
                                              ],
                                            ))
                                        .toList(), 
                                  ),
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
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 1),
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 28,
                                    color: Colors.blue,
                                    icon: Icon(Icons.link),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Text("링크 복사")
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 1),
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 28,
                                    color: Colors.yellow,
                                    icon: Icon(Icons.link),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Text("카카오톡")
                            ],
                          )
                        ]
                        // children: List.generate(3, (index) => Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       CircleAvatar(),
                        //       Text('링크복사'),
                        //     ],
                        //   ),
                        // ),),
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
                        Text('포인티 센터'),
                        Text('서울시 남부순환로 1801, 라피스 빌딩 8층'),
                        Text('02-840-9002'),
                        Row(
                          children: [
                            Text('카카오톡 문의 :'),
                            TextButton(
                              onPressed: () {},
                              child: Text('포인티 센터 바로가기', style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),),
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