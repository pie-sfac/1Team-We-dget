import 'package:camera_for_measurement/common/const/custom_colors.dart';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'pretendard',
          colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.Primary_500,
          ),
        ),
        home: Home(),
      ),
    ),
  );
}
