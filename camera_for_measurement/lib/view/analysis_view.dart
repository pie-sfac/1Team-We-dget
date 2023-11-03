import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/const/custom_units.dart';
import '../provider/picture_provider.dart';
import '../provider/pose_info_provider.dart';

class AnalysisView extends ConsumerStatefulWidget {
  const AnalysisView({super.key});

  @override
  ConsumerState<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends ConsumerState<AnalysisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자세 측정 카메라'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CustomUnits.margin,
          ),
          child: ListView(
            children: [
              if (ref.watch(pictureProvider.notifier).state != null)
                Image.file(
                  File(ref.watch(pictureProvider.notifier).state!.path),
                ),
              Text('${ref.watch(poseInfoProvider.notifier).state}'),
            ],
          ),
        ),
      ),
    );
  }
}
