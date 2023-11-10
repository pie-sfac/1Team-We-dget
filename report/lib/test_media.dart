import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:report/common/const/custom_colors.dart';
import 'package:report/model/person.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio dio = Dio();
  Person? person;

  Future<Person?> fetchData() async {
    var url = "https://flutterapi.tykan.me/personal-reports/";
    var uuid = "4d61d864-4885-4fff-a2f5-07f9b599885d";
    var res = await dio.get(url + uuid);

    if (res.statusCode == 200) {
      person = Person.fromMap(res.data);
      print(res.data['member']['name']);
      print(person!.member.name);
      return person;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('${person!.member.name} 회원님'),
          centerTitle: false,
          backgroundColor: const Color.fromARGB(0, 17, 17, 17),
          foregroundColor: Colors.black,
          actions: [
            Row(
              children: [
                Row(children: [
                  Text('과거 레포트 보러가기'),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(Icons.navigate_next),
                  ), // 페이지 이동.
                ])
              ],
            )
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListView(
              children: [
                renderTitle('${person!.member.name} 회원님 영상 및 이미지'),
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
                              child: Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 100,
                                        height: 100,
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
                                      Container(
                                        width: 100,
                                        height: 100,
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
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget renderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}